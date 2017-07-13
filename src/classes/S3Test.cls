/**
 * @author bigassforce
 * Amazon Simple Storage Service SDK for Salesforce Apex
 */
@IsTest class S3Test {

    class MockRequest {
        String contentType;
        String cacheControl;
        String contentLength;
        String lastModified;
    }

    static testmethod void testRequestFormatter() {
        //arrange
        MockRequest request = new MockRequest();
        request.contentType = 'text/plain';
        request.cacheControl = 'private';
        request.contentLength = '0';
        request.lastModified = 'Thu, 17 Mar 2016 12:41:00 GMT';

        //act
        Map<String,String> headers = new S3.RequestFormatter(request).getMap();

        //assert
        System.assertEquals('text/plain', headers.get('content-type'), 'wrong content-type');
        System.assertEquals('private', headers.get('cache-control'), 'wrong cache-control');
        System.assertEquals('0', headers.get('content-length'), 'wrong content-length');
        System.assertEquals('Thu, 17 Mar 2016 12:41:00 GMT', headers.get('last-modified'), 'wrong last-modified');
    }

    class MockListBucketsResponder implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            String body = ''
                + '<?xml version="1.0" encoding="UTF-8"?>'
                + '<ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">'
                + '    <Owner>'
                + '        <ID>7eb62a270db16c8c2d52df0bff260b20c0fabeaf3df84775c040269de4547f47</ID>'
                + '        <DisplayName>eddie22willers</DisplayName>'
                + '    </Owner>'
                + '    <Buckets>'
                + '        <Bucket>'
                + '            <Name>bucketname</Name>'
                + '            <CreationDate>2016-04-26T17:19:36.000Z</CreationDate>'
                + '        </Bucket>'
                + '    </Buckets>'
                + '</ListAllMyBucketsResult>'
            ;

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody(body);
            return response;
        }
    }

    static testmethod void testListBuckets() {
        //arrange
        Test.setMock(HttpCalloutMock.class, new MockListBucketsResponder());

        //act
        S3 s3 = new Connector('access', 'secret').s3('us-east-1', 's3.us-east-1.amazonaws.com');
        List<S3.Bucket> buckets = s3.listBuckets();

        //assert
        System.assertEquals(1, buckets.size(), 'wrong buckets');
        System.assertEquals('bucketname', buckets[0].Name, 'wrong name');
        System.assertEquals(Datetime.newInstanceGmt(2016, 04, 26, 17, 19, 36), buckets[0].CreationDate, 'wrong date');
    }

    class MockCreateBucketResponder implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            return response;
        }
    }

    static testmethod void testCreateBucket() {
        //arrange
        Test.setMock(HttpCalloutMock.class, new MockCreateBucketResponder());

        //act
        S3 s3 = new Connector('access', 'secret').s3('us-east-1', 's3.us-east-1.amazonaws.com');
        HttpResponse response = s3.createBucket('bucketname');

        //assert
        System.assertEquals(200, response.getStatusCode(), 'wrong status code');
    }

    class MockDeleteBucketResponder implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(204);
            return response;
        }
    }

    static testmethod void testDeleteBucket() {
        //arrange
        Test.setMock(HttpCalloutMock.class, new MockDeleteBucketResponder());

        //act
        S3 s3 = new Connector('access', 'secret').s3('us-east-1', 's3.us-east-1.amazonaws.com');
        HttpResponse response = s3.deleteBucket('bucketname');

        //assert
        System.assertEquals(204, response.getStatusCode(), 'wrong status code');
    }

    class MockListContentsResponder implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            String body = ''
                + '<?xml version="1.0" encoding="UTF-8"?>'
                + '<ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">'
                + '    <Name>bucketname</Name>'
                + '    <Prefix></Prefix>'
                + '    <Marker></Marker>'
                + '    <MaxKeys>1000</MaxKeys>'
                + '    <IsTruncated>false</IsTruncated>'
                + '    <Contents>'
                + '        <Key>nospaces1.png</Key>'
                + '        <LastModified>2016-04-27T06:30:58.000Z</LastModified>'
                + '        <ETag>&quot;aaaabbbbccccddddaaaabbbbccccdddd&quot;</ETag>'
                + '        <Size>40472</Size>'
                + '        <Owner>'
                + '            <ID>id1</ID>'
                + '            <DisplayName>name1</DisplayName>'
                + '        </Owner>'
                + '        <StorageClass>STANDARD</StorageClass>'
                + '    </Contents>'
                + '    <Contents>'
                + '        <Key>nospaces2.png</Key>'
                + '        <LastModified>2016-04-27T06:31:03.000Z</LastModified>'
                + '        <ETag>&quot;aaaabbbbccccddddaaaabbbbccccdddd&quot;</ETag>'
                + '        <Size>116463</Size>'
                + '        <Owner>'
                + '            <ID>id2</ID>'
                + '            <DisplayName>name2</DisplayName>'
                + '        </Owner>'
                + '        <StorageClass>STANDARD</StorageClass>'
                + '    </Contents>'
                + '</ListBucketResult>'
            ;

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody(body);
            return response;
        }
    }

    static testmethod void testListContents() {
        //arrange
        Test.setMock(HttpCalloutMock.class, new MockListContentsResponder());

        //act
        S3 s3 = new Connector('access', 'secret').s3('us-east-1', 's3.us-east-1.amazonaws.com');
        List<S3.Content> contents = s3.bucket('bucketname').listContents(null);

        //assert
        System.assertEquals(2, contents.size(), 'wrong contents');

        System.assertEquals('nospaces1.png', contents[0].Key);
        System.assertEquals(Datetime.newInstanceGmt(2016, 04, 27, 06, 30, 58), contents[0].LastModified);
        System.assertEquals('"aaaabbbbccccddddaaaabbbbccccdddd"', contents[0].ETag, 'wrong etag');
        System.assertEquals('40472', contents[0].Size, 'wrong size');
        System.assertEquals('id1', contents[0].Owner.ID, 'wrong owner id');
        System.assertEquals('name1', contents[0].Owner.DisplayName, 'wrong owner name');
        System.assertEquals('STANDARD', contents[0].StorageClass, 'wrong storage class');

        System.assertEquals('nospaces2.png', contents[1].Key);
        System.assertEquals(Datetime.newInstanceGmt(2016, 04, 27, 06, 31, 03), contents[1].LastModified);
        System.assertEquals('"aaaabbbbccccddddaaaabbbbccccdddd"', contents[1].ETag, 'wrong etag');
        System.assertEquals('116463', contents[1].Size, 'wrong size');
        System.assertEquals('id2', contents[1].Owner.ID, 'wrong owner id');
        System.assertEquals('name2', contents[1].Owner.DisplayName, 'wrong owner name');
        System.assertEquals('STANDARD', contents[1].StorageClass, 'wrong storage class');
    }

    class MockCreateContentResponder implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            return response;
        }
    }

    static testmethod void testCreateContent() {
        //arrange
        Test.setMock(HttpCalloutMock.class, new MockCreateContentResponder());

        //act
        S3 s3 = new Connector('access', 'secret').s3('us-east-1', 's3.us-east-1.amazonaws.com');
        HttpResponse response = s3.bucket('bucketname').createContent('directory/file.txt', null, null);

        //assert
        System.assertEquals(200, response.getStatusCode(), 'wrong status code');
    }

    class MockDeleteContentResponder implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(204);
            return response;
        }
    }

    static testmethod void testDeleteContent() {
        //arrange
        Test.setMock(HttpCalloutMock.class, new MockDeleteContentResponder());

        //act
        S3 s3 = new Connector('access', 'secret').s3('us-east-1', 's3.us-east-1.amazonaws.com');
        HttpResponse response = s3.bucket('bucketname').deleteContent('path/to/file.ext');

        //assert
        System.assertEquals(204, response.getStatusCode(), 'wrong status code');
    }

    static testmethod void testPresign() {
        //arrange
        Connector connector = new Connector('access', 'secret');
        connector.now = Datetime.newInstanceGmt(2015, 08, 30, 12, 36, 00);

        //act
        HttpRequest request = connector.s3('us-east-1', 's3.us-east-1.amazonaws.com').bucket('bucketname').content('path/to/file.ext').presign();

        //assemble
        Url endpoint = new Url(request.getEndpoint());
        Map<String,String> parameters = new PageReference('/?' + endpoint.getQuery()).getParameters();

        //assert
        System.assertEquals('https', endpoint.getProtocol(), 'wrong protocol');
        System.assertEquals('bucketname.s3.us-east-1.amazonaws.com', endpoint.getHost(), 'wrong host');
        System.assertEquals('/path/to/file.ext', endpoint.getPath(), 'wrong path');

        System.assertEquals('AWS4-HMAC-SHA256', parameters.get('X-Amz-Algorithm'), 'wrong algorithm');
        System.assertEquals('access/20150830/us-east-1/s3/aws4_request', parameters.get('X-Amz-Credential'), 'wrong credential');
        System.assertEquals('20150830T123600Z', parameters.get('X-Amz-Date'), 'wrong date');
        System.assertEquals('86400', parameters.get('X-Amz-Expires'), 'wrong expires');
        System.assertEquals('d1f8048e80dc8fbb4343bd716e1db263f8515737f33cacb28c79fb64486f7e8e', parameters.get('X-Amz-Signature'), 'wrong signature');
        System.assertEquals('host', parameters.get('X-Amz-SignedHeaders'), 'wrong signature');
    }


}