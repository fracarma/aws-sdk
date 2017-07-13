/**
 * @author bigassforce
 * Amazon Web Services SDK for Salesforce Apex
 *
 * Example usage:
 * String key = 'XXXXXXXXXXXXXXXXXXXX';
 * String secret = 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY';
 * AwsSdk.S3 s3 = new AwsSdk.Connector(key, secret).s3('us-east-1', 'https://s3.us-east-1.amazonaws.com');
 * AwsSdk.Ec2 ec2 = new AwsSdk.Connector(key, secret).ec2('us-east-1', 'https://s3.us-east-1.amazonaws.com');
 */
public class Connector {

    String accessKeyId;
    String secretKey;
    public String service;
    public String region;
    public String baseURL;
    @TestVisible Datetime now = Datetime.now();

    public Connector(String accessKeyId, String secretKey) {
        this.accessKeyId = accessKeyId;
        this.secretKey = secretKey;
    }

    public S3 s3(String region, String baseURL) {
        return new S3(this, region, baseURL);
    }    

    public S3 s3(String region) {
        return new S3(this, region, null);
    }

    public Ec2 ec2(String region, String baseURL) {
        return new ec2(this, region, baseURL);
    }    
    public Ec2 ec2(String region) {
        return new ec2(this, region, null);
    }

    /**
     * Signature Version 4 Signing Process
     * Requests to AWS must be signed—that is, they must include information that AWS can use to authenticate the
     * requestor. Requests are signed using the access key ID and secret access key of an account or of an IAM user.
     * https://docs.aws.amazon.com/general/latest/gr/signing_aws_api_requests.html
     */
    public HttpRequest signedRequest(String method, Url endpoint, Map<String,String> headers, Blob payload, Boolean presign) {

        //defaults
        if (headers == null) headers = new Map<String,String>();
        if (payload == null) payload = Blob.valueOf('');
        if (presign == null) presign = false;

        //assemble

        String termination = 'aws4_request';
        String iso8601date = this.now.formatGmt('YYYYMMdd');
        String iso8601time = this.now.formatGmt('YYYYMMdd\'T\'HHmmss\'Z\'');
        String credentialScope = iso8601date + '/' + this.region + '/' + this.service + '/' + termination;

        //prepare headers
        headers.put('Host', endpoint.getHost());
        String signedHeaders = signedHeadersFor(headers);

        //handle spaces and special characters in paths
        String spec = '';
        spec += endpoint.getProtocol() + '://';
        spec += endpoint.getHost();
        spec += rfc3986For(endpoint.getPath(), false);
        if (endpoint.getQuery() != null) spec += '?' + endpoint.getQuery();

        //prepare parameters
        PageReference pr = new PageReference(spec);
        Map<String,String> parameters = pr.getParameters();
        parameters.put('X-Amz-Algorithm', 'AWS4-HMAC-SHA256');
        parameters.put('X-Amz-Credential', this.accessKeyId + '/' + credentialScope);
        parameters.put('X-Amz-Date', iso8601time);
        parameters.put('X-Amz-Expires', '86400');
        parameters.put('X-Amz-SignedHeaders', signedHeaders);

        //Task 1: Create a Canonical Request for Signature Version 4
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
        String canonicalRequest = canonicalMethodFor(method)
            + '\n' + canonicalUriFor(endpoint.toExternalForm())
            + '\n' + canonicalQueryStringFor(parameters)
            + '\n' + canonicalHeadersFor(headers)
            + '\n' + signedHeadersFor(headers)
            + '\n' + (presign ? 'UNSIGNED-PAYLOAD' : hexEncodedHashFor(payload))
        ;
        system.debug('@@parameters: '+parameters);
        system.debug('@@canonicalRequest: '+canonicalRequest);

        //Task 2: Create a String to Sign for Signature Version 4
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-create-string-to-sign.html
        String algorithm = 'AWS4-HMAC-SHA256';
        String canonicalRequestHash = hexEncodedHashFor(Blob.valueOf(canonicalRequest));
        String stringToSign = algorithm + '\n' + iso8601time + '\n' + credentialScope + '\n' + canonicalRequestHash;

        //Task 3: Calculate the AWS Signature Version 4
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-calculate-signature.html
        Blob keySecret = Blob.valueOf('AWS4' + this.secretKey);
        Blob keyDate = Crypto.generateMac('hmacSHA256', Blob.valueOf(iso8601date), keySecret);
        Blob keyRegion = Crypto.generateMac('hmacSHA256', Blob.valueOf(this.region), keyDate);
        Blob keyService = Crypto.generateMac('hmacSHA256', Blob.valueOf(this.service), keyRegion);
        Blob keySigning = Crypto.generateMac('hmacSHA256', Blob.valueOf('aws4_request'), keyService);
        Blob blobToSign = Blob.valueOf(stringToSign);
        Blob hmac = Crypto.generateMac('hmacSHA256', blobToSign, keySigning);

        //Task 4: Add the Signing Information to the Request
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-add-signature-to-request.html
        if (!presign) headers.put('X-Amz-Content-Sha256', hexEncodedHashFor(payload));
        String signature = EncodingUtil.convertToHex(hmac);
        parameters.put('X-Amz-Signature', signature);

        //prepare request
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(pr.getUrl());
        if (payload != Blob.valueOf('')) request.setBodyAsBlob(payload); //affects http method
        for (String header : headers.keySet()) request.setHeader(header, headers.get(header));

        return request;
    }

    /**
     * Start with the HTTP request method (GET, PUT, POST, etc.), followed by a newline character.
     * https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
     */
    @TestVisible static String canonicalMethodFor(String method) {
        return method.toUpperCase();
    }

    /**
     * The canonical URI is the URI-encoded version of the absolute path component of the URI, which is everything in
     * the URI from the HTTP host to the question mark character
     * http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
     */
    @TestVisible static String canonicalUriFor(String endpoint) {
        Url uri = new Url(endpoint);
        return rfc3986For(uri.getPath(), false);
    }

    /**
     * To construct the canonical query string, complete the following steps:
     * a. URI-encode each parameter name and value.
     * b. Sort the encoded parameter names by character code in ascending order (ASCII order).
     * c. Build the canonical query string by starting with the first parameter name in the sorted list.
     * d. For each parameter, append the URI-encoded parameter name, followed by '=' followed by the URI-encoded value
     * e. Append the character '&' (ASCII code 38) after each parameter value, except for the last value in the list.
     * https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
     */
    @TestVisible static String canonicalQueryStringFor(Map<String,String> parameters) {
        
        //sort keys by ascii code
        List<String> sortedKeys = new List<String>(parameters.keySet());
        sortedKeys.sort();
        
        //prepare values
        List<String> canonicalParameters = new List<String>();
        for (String sortedKey : sortedKeys) canonicalParameters.add(
            sortedKey + 
            '=' + 
            rfc3986For(parameters.get(sortedKey), true)
        );
        
        return String.join(canonicalParameters, '&');
    }

    /**
     * To create the canonical headers list, convert all header names to lowercase and remove leading spaces and
     * trailing spaces. Convert sequential spaces in the header value to a single space.
     * https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
     */
    @TestVisible static String canonicalHeadersFor(Map<String,String> key2value) {
        
        //lowercase header keys
        Map<String,String> lower2value = new Map<String,String>();
        for (String key : key2value.keySet()) lower2value.put(key.toLowerCase(), key2value.get(key).trim().replaceAll('\\s+', ' '));
        
        //sort canonical keys by ascii code
        List<String> sortedKeys = new List<String>(lower2value.keySet());
        sortedKeys.sort();
        
        //prepare values
        List<String> canonicalHeaders = new List<String>();
        for (String sortedKey : sortedKeys) canonicalHeaders.add(sortedKey + ':' + lower2value.get(sortedKey) + '\n');
        
        return String.join(canonicalHeaders, '');
    }

    /**
     * Build the signed headers list by iterating through the collection of header names, sorted by lowercase character
     * code. For each header name except the last, append a semicolon (';') to the header name to separate it from the
     * following header name.
     * https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
     */
    @TestVisible static String signedHeadersFor(Map<String,String> headers) {
        
        //lowercase header keys
        List<String> keys = new List<String>(headers.keySet());
        for (Integer i = 0; i < keys.size(); i++) keys.set(i, keys[i].toLowerCase());
        
        //sort ascii
        keys.sort();
        
        //prepare values
        List<String> signedHeaders = new List<String>();
        for (String key : keys) signedHeaders.add(key);
        
        return String.join(signedHeaders, ';');
    }

    /**
     * The hashed canonical request must be represented as a string of lowercase hexademical characters.
     * https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
     */
    @TestVisible static String hexEncodedHashFor(Blob data) {
        Blob hash = Crypto.generateDigest('SHA256', data);
        return EncodingUtil.convertToHex(hash);
    }

    /**
     * Caution: The standard UriEncode functions provided by your development platform may not work because of
     * differences in implementation and related ambiguity in the underlying RFCs. We recommend that you write your own
     * custom UriEncode function to ensure that your encoding will work.
     * https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-query-string-auth.html
     */
    @TestVisible static String rfc3986For(String characters, Boolean encodeSlash) {
        String result = '';
        for (Integer i = 0; i < characters.length(); i++) {
            String character = characters.substring(i, i + 1);
            
            if (
                (character >= 'A' && character <= 'Z') || 
                (character >= 'a' && character <= 'z') || 
                (character >= '0' && character <= '9') || 
                character == '_' || 
                character == '-' || 
                character == '~' || 
                character == '.'
            ) {
                result += character;
            } else if (character == '/') {
                result += encodeSlash ? '%2F' : character;
            } else {
                result += '%' + EncodingUtil.convertToHex(Blob.valueOf(character)).toUpperCase();
            }
        }
        
        return result;
    }

}