/**
 * @author bigassforce
 * Amazon Elastic Compute Cloud SDK for Salesforce Apex
 *
 * Example usage:
 *
 * String accessKey = 'XXXXXXXXXXXXXXXXXXXX';
 * String secretkey = 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY';
 * AwsSdk.Connector connector = new AwsSdk.Connector(accessKey, secretKey);
 *
 * String region = 'eu-east-1';
 * AwsSdk.Ec2 ec2 = connector.ec2(region);
* String baseURL = s3.us-east-1.amazonaws.com';
 * AwsSdk.Ec2.DescribeInstancesResponse response = ec2.describeInstances(null);
 */
public class Ec2 {

    class ClientException extends Exception {}

    Connector connector;
    public Ec2(Connector connector, String region) {
        this.connector = connector;
        this.connector.region = region;
        this.connector.service = 'ec2';
        this.connector.baseURL = baseURL;
    }

    /**
     * Describes one or more of your instances.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeInstances.html
     */
    public class DescribeInstancesRequest {

        /**
         * Checks whether you have the required permissions for the action, without actually making the
         * request, and provides an error response. If you have the required permissions, the error response
         * is DryRunOperation. Otherwise, it is UnauthorizedOperation.
         */
        public Boolean DryRun;

        /**
         * One or more filters.
         */
        public List<Filter> Filter;

        /**
         * One or more instance IDs.
         */
        public List<String> InstanceId;

        /**
         * The maximum number of results to return in a single call. To retrieve the remaining results, make
         * another call with the returned NextToken value. This value can be between 5 and 1000. You cannot
         * specify this parameter and the instance IDs parameter in the same call.
         */
        public Integer MaxResults;

        /**
         * The token to request the next page of results.
         */
        public String NextToken;

    }

    /**
     * A filter name and value pair that is used to return a more specific list of results.
     * Filters can be used to match a set of resources by various criteria, such as tags, attributes, or IDs.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Filter.html
     */
    public class Filter {

        /**
         * The name of the filter. Filter names are case-sensitive.
         */
        public String Name;

        /**
         * One or more filter values. Filter values are case-sensitive.
         */
        public List<String> Value;

    }

    /**
     * Describes one or more regions that are currently available to you.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeRegions.html
     */
    public class DescribeRegionsRequest {

        /**
         * Checks whether you have the required permissions for the action, without actually making the
         * request, and provides an error response. If you have the required permissions, the error response
         * is DryRunOperation. Otherwise, it is UnauthorizedOperation.
         */
        public Boolean DryRun;

        /**
         * One or more filters.
         */
        public List<Filter> Filter;

        /**
         * The names of one or more regions.
         */
        public List<String> RegionName;

    }

    /**
     * Launches the specified number of instances using an AMI for which you have permissions.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_RunInstances.html
     */
    public class RunInstancesRequest {

        /**
         * Reserved.
         */
        public String AdditionalInfo;

        /**
         * The block device mapping.
         */
        public List<BlockDeviceMapping> BlockDeviceMapping;

        /**
         * Unique, case-sensitive identifier you provide to ensure the idempotency of the request.
         */
        public String ClientToken;

        /**
         * If you set this parameter to true, you can't terminate the instance using the Amazon EC2 console,
         * CLI, or API; otherwise, you can. If you set this parameter to true and then later want to be able
         * to terminate the instance, you must first change the value of the disableApiTermination attribute
         * to false using ModifyInstanceAttribute.
         *
         * Alternatively, if you set InstanceInitiatedShutdownBehavior to terminate, you can terminate the
         * instance by running the shutdown command from the instance.
         */
        public Boolean DisableApiTermination;

        /**
         * Checks whether you have the required permissions for the action, without actually making the
         * request, and provides an error response. If you have the required permissions, the error response
         * is DryRunOperation. Otherwise, it is UnauthorizedOperation.
         */
        public Boolean DryRun;

        /**
         * Indicates whether the instance is optimized for EBS I/O. This optimization provides dedicated
         * throughput to Amazon EBS and an optimized configuration stack to provide optimal EBS I/O
         * performance. This optimization isn't available with all instance types. Additional usage charges
         * apply when using an EBS-optimized instance.
         */
        public Boolean EbsOptimized;

        /**
         * The IAM instance profile.
         */
        public IamInstanceProfileSpecification IamInstanceProfile;

        /**
         * The ID of the AMI, which you can get by calling DescribeImages.
         */
        public String ImageId;

        /**
         * Indicates whether an instance stops or terminates when you initiate shutdown from the instance
         * (using the operating system command for system shutdown).
         */
        public String InstanceInitiatedShutdownBehavior;

        /**
         * The instance type. For more information, see Instance Types in the Amazon Elastic Compute Cloud
         * User Guide.
         */
        public String InstanceType = 't2.micro';

        /**
         * The ID of the kernel.
         */
        public String KernelId;

        /**
         * The name of the key pair. You can create a key pair using CreateKeyPair or ImportKeyPair.
         */
        public String KeyName;

        /**
         * The maximum number of instances to launch. If you specify more instances than Amazon EC2 can
         * launch in the target Availability Zone, Amazon EC2 launches the largest possible number of
         * instances above MinCount.
         */
        public Integer MaxCount = 1;

        /**
         * The minimum number of instances to launch. If you specify a minimum that is more instances than
         * Amazon EC2 can launch in the target Availability Zone, Amazon EC2 launches no instances.
         */
        public Integer MinCount = 1;

        /**
         * The monitoring for the instance.
         */
        public RunInstancesMonitoringEnabled Monitoring;

        /**
         * One or more network interfaces.
         */
        public List<InstanceNetworkInterfaceSpecification> NetworkInterface;

        /**
         * The placement for the instance.
         */
        public Placement Placement;

        /**
         * The primary IP address. You must specify a value from the IP address range of the subnet.
         */
        public String PrivateIpAddress;

        /**
         * The ID of the RAM disk.
         */
        public String RamdiskId;

        /**
         * One or more security group IDs. You can create a security group using CreateSecurityGroup.
         */
        public List<String> SecurityGroupId;

        /**
         * One or more security group names. For a nondefault VPC, you must use security group IDs instead.
         */
        public List<String> SecurityGroup;

        /**
         * The ID of the subnet to launch the instance into.
         */
        public String SubnetId;

        /**
         * Data to configure the instance, or a script to run during instance launch. For more information,
         * see Running Commands on Your Linux Instance at Launch (Linux) and Adding User Data (Windows). For
         * API calls, the text must be base64-encoded. For command line tools, the encoding is performed for
         * you, and you can load the text from a file.
         */
        public String UserData;

    }

    /**
     * Describes an IAM instance profile.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_IamInstanceProfileSpecification.html
     */
    public class IamInstanceProfileSpecification {

        /**
         * The Amazon Resource Name (ARN) of the instance profile.
         */
        public String Arn;

        /**
         * The name of the instance profile.
         */
        public String Name;

    }

    /**
     * Describes the monitoring for the instance.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_RunInstancesMonitoringEnabled.html
     */
    public class RunInstancesMonitoringEnabled {

        /**
         * Indicates whether monitoring is enabled for the instance.
         */
        public Boolean Enabled;

    }

    /**
     * Describes a network interface.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstanceNetworkInterfaceSpecification.html
     */
    public class InstanceNetworkInterfaceSpecification {

        /**
         * Indicates whether to assign a public IP address to an instance you launch in a VPC. The public IP
         * address can only be assigned to a network interface for eth0, and can only be assigned to a new
         * network interface, not an existing one. You cannot specify more than one network interface in the
         * request. If launching into a default subnet, the default value is true.
         */
        public Boolean AssociatePublicIpAddress;

        /**
         * If set to true, the interface is deleted when the instance is terminated. You can specify true
         * only if creating a new network interface when launching an instance.
         */
        public Boolean DeleteOnTermination;

        /**
         * The description of the network interface. Applies only if creating a network interface when
         * launching an instance.
         */
        public String Description;

        /**
         * The index of the device on the instance for the network interface attachment. If you are specifying
         * a network interface in a RunInstances request, you must provide the device index.
         */
        public Integer DeviceIndex;

        /**
         * The IDs of the security groups for the network interface. Applies only if creating a network
         * interface when launching an instance.
         */
        public List<String> SecurityGroupId;

        /**
         * The ID of the network interface.
         */
        public String NetworkInterfaceId;

        /**
         * The private IP address of the network interface. Applies only if creating a network interface when
         * launching an instance.
         */
        public String PrivateIpAddress;

        /**
         * One or more private IP addresses to assign to the network interface. Only one private IP address
         * can be designated as primary.
         */
        public List<PrivateIpAddressSpecification> PrivateIpAddressesSet;

        /**
         * The number of secondary private IP addresses. You can't specify this option and specify more than
         * one private IP address using the private IP addresses option.
         */
        public Integer SecondaryPrivateIpAddressCount;

        /**
         * The ID of the subnet associated with the network string. Applies only if creating a network
         * interface when launching an instance.
         */
        public String SubnetId;
    }

    /**
     * Describes a secondary private IP address for a network interface.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PrivateIpAddressSpecification.html
     */
    public class PrivateIpAddressSpecification {

        /**
         * Indicates whether the private IP address is the primary private IP address. Only one IP address
         * can be designated as primary.
         */
        public Boolean Primary;

        /**
         * The private IP addresses.
         */
        public String PrivateIpAddress;

    }

    public class TerminateInstancesRequest {

        /**
         * Checks whether you have the required permissions for the action, without actually making the request, and
         * provides an error response. If you have the required permissions, the error response is DryRunOperation.
         * Otherwise, it is UnauthorizedOperation.
         */
        public Boolean DryRun;

        /**
         * One or more instance IDs.
         */
        public List<String> InstanceId;

    }

    /**
     * Describes one or more of your instances.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeInstances.html
     * 
     * Ec2.DescribeInstancesRequest request = new Ec2.DescribeInstancesRequest();
     * request.InstanceId = new List<String>{'i-00cf11c1'};
     * client.describeInstances(request);
     */
    public DescribeInstancesResponse describeInstances(DescribeInstancesRequest describeInstancesRequest) {
        Map<String,String> parameters = new RequestFormatter(describeInstancesRequest).getMap();
        parameters.put('Version', '2015-10-01');
        parameters.put('Action', 'DescribeInstances');

        PageReference pr = new PageReference('https://ec2.' + this.connector.region + '.amazonaws.com/');
        pr.getParameters().putAll(parameters);

        Url endpoint = new Url(pr.getUrl());
        HttpRequest request = this.connector.signedRequest('GET', endpoint, null, null, null);
        HttpResponse response = new Http().send(request);
        if (response.getStatusCode() != 200) throw new ClientException(response.getBody());

        String data = new ResponseFormatter(response.getBodyDocument()).getJson();
        Object dto = Json.deserialize(data, DescribeInstancesResponse.class);
        return (DescribeInstancesResponse)dto;
    }

    /**
     * Describes one or more regions that are currently available to you.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Region.html
     *
     * Ec2.DescribeRegionsRequest request = new Ec2.DescribeRegionsRequest();
     * request.RegionName = new List<String>{'us-east-1'};
     * client.describeRegions(request);
     */
    public DescribeRegionsResponse describeRegions(DescribeRegionsRequest describeRegionsRequest) {
        Map<String,String> parameters = new RequestFormatter(describeRegionsRequest).getMap();
        parameters.put('Version', '2015-10-01');
        parameters.put('Action', 'DescribeRegions');

        PageReference pr = new PageReference('https://ec2.' + this.connector.region + '.amazonaws.com/');
        pr.getParameters().putAll(parameters);

        Url endpoint = new Url(pr.getUrl());
        HttpRequest request = this.connector.signedRequest('GET', endpoint, null, null, null);
        HttpResponse response = new Http().send(request);
        if (response.getStatusCode() != 200) throw new ClientException(response.getBody());

        String data = new ResponseFormatter(response.getBodyDocument()).getJson();
        Object dto = Json.deserialize(data, DescribeRegionsResponse.class);
        return (DescribeRegionsResponse)dto;
    }

    /**
     * Launches the specified number of instances using an AMI for which you have permissions.
     * http://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_RunInstances.html
     * 
     * Ec2.RunInstancesRequest request = new Ec2.RunInstancesRequest();
     * request.ImageId = 'ami-08111162';
     * client.runInstances(request);
     */
    public RunInstancesResponse runInstances(RunInstancesRequest runInstancesRequest) {
        Map<String,String> parameters = new RequestFormatter(runInstancesRequest).getMap();
        parameters.put('Version', '2015-10-01');
        parameters.put('Action', 'RunInstances');

        PageReference pr = new PageReference('https://ec2.' + this.connector.region + '.amazonaws.com/');
        pr.getParameters().putAll(parameters);

        Url endpoint = new Url(pr.getUrl());
        HttpRequest request = this.connector.signedRequest('GET', endpoint, null, null, null);
        HttpResponse response = new Http().send(request);
        if (response.getStatusCode() != 200) throw new ClientException(response.getBody());
        
        String data = new ResponseFormatter(response.getBodyDocument()).getJson();
        Object dto = Json.deserialize(data, RunInstancesResponse.class);
        return (RunInstancesResponse)dto;
    }

    /**
     * Shuts down one or more instances.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_TerminateInstances.html
     */
    public TerminateInstancesResponse terminateInstances(TerminateInstancesRequest terminateInstancesRequest) {
        Map<String,String> parameters = new RequestFormatter(terminateInstancesRequest).getMap();
        parameters.put('Version', '2015-10-01');
        parameters.put('Action', 'TerminateInstances');

        PageReference pr = new PageReference('https://ec2.' + this.connector.region + '.amazonaws.com/');
        pr.getParameters().putAll(parameters);

        Url endpoint = new Url(pr.getUrl());
        HttpRequest request = this.connector.signedRequest('GET', endpoint, null, null, null);
        HttpResponse response = new Http().send(request);
        if (response.getStatusCode() != 200) throw new ClientException(response.getBody());

        String data = new ResponseFormatter(response.getBodyDocument()).getJson();
        Object dto = Json.deserialize(data, TerminateInstancesResponse.class);
        return (TerminateInstancesResponse)dto;
    }

    /**
     * Describes one or more of your instances.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeInstances.html
     */
    public class DescribeInstancesResponse {

        /**
         * The ID of the request.
         */
        public String requestId;

        /**
         * Zero or more reservations.
         */
        public List<Reservation> reservationSet;

    }

    /**
     * Describes a reservation.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Reservation.html
     */
    public class Reservation {

        /**
         * One or more security groups.
         */
        public List<SecurityGroup> groupSet;

        /**
         * One or more instances.
         */
        public List<Instance> instancesSet;

        /**
         * The ID of the AWS account that owns the reservation.
         */
        public String ownerId;

        /**
         * The ID of the reservation.
         */
        public String reservationId;
    }

    /**
     * Describes a security group.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_GroupIdentifier.html
     */
    public class SecurityGroup {

        /**
         * The ID of the security group.
         */
        public String groupId;

        /**
         * The name of the security group.
         */
        public String groupName;
    }

    /**
     * Describes an instance.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Instance.html
     */
    public class Instance {

        /**
         * The AMI launch index, which can be used to find this instance in the launch group.
         */
        public String amiLaunchIndex;

        /**
         * The architecture of the image.
         */
        public String architecture;

        /**
         * Any block device mapping entries for the instance.
         */
        public List<BlockDeviceMapping> blockDeviceMapping;

        /**
         * The idempotency token you provided when you launched the instance, if applicable.
         */
        public String clientToken;

        /**
         * Indicates whether the instance is optimized for EBS I/O. This optimization provides dedicated
         * throughput to Amazon EBS and an optimized configuration stack to provide optimal I/O performance.
         * This optimization isn't available with all instance types. Additional usage charges apply when
         * using an EBS Optimized instance.
         */
        public Boolean ebsOptimized;

        /**
         * The hypervisor type of the instance.
         */
        public String hypervisor;

        /**
         * The ID of the AMI used to launch the instance.
         */
        public String imageId;

        /**
         * The ID of the instance.
         */
        public String instanceId;

        /**
         * The instance type.
         */
        public String instanceType;

        /**
         * The name of the key pair, if this instance was launched with an associated key pair.
         */
        public String keyName;

        /**
         * The time the instance was launched.
         */
        public Datetime launchTime;

        /**
         * The monitoring information for the instance.
         */
        public Monitoring monitoring;

        /**
         * One or more network interfaces for the instance.
         */
        public List<NetworkInterface> networkInterfaceSet;

        /**
         * The location where the instance launched, if applicable.
         */
        public Placement placement;

        /**
         * The private DNS name assigned to the instance. This DNS name can only be used inside the Amazon EC2
         * network. This name is not available until the instance enters the running state. For EC2-VPC, this
         * name is only available if you've enabled DNS hostnames for your VPC.
         */
        public String privateDnsName;

        /**
         * The private IP address assigned to the instance.
         */
        public String privateIpAddress;

        /**
         * The product codes attached to this instance, if applicable.
         */
        public List<ProductCode> productCodes;

        /**
         * The public DNS name assigned to the instance. This name is not available until the instance enters
         * the running state. For EC2-VPC, this name is only available if you've enabled DNS hostnames for
         * your VPC.
         */
        public String dnsName;

        /**
         * The public IP address assigned to the instance, if applicable.
         */
        public String ipAddress;

        /**
         * The root device name (for example, /dev/sda1 or /dev/xvda).
         */
        public String rootDeviceName;

        /**
         * The root device type used by the AMI. The AMI can use an EBS volume or an instance store volume.
         */
        public String rootDeviceType;

        /**
         * One or more security groups for the instance.
         */
        public List<SecurityGroup> groupSet;

        /**
         * Specifies whether to enable an instance launched in a VPC to perform NAT. This controls whether
         * source/destination checking is enabled on the instance. A value of true means checking is enabled,
         * and false means checking is disabled. The value must be false for the instance to perform NAT. For
         * more information, see NAT Instances in the Amazon Virtual Private Cloud User Guide.
         */
        public Boolean sourceDestCheck;

        /**
         * The private IP address assigned to the instance.
         */
        public InstanceState instanceState;

        /**
         * The reason for the most recent state transition. This might be an empty string.
         */
        public Reason reason;

        /**
         * The ID of the subnet in which the instance is running.
         */
        public String subnetId;

        /**
         * Any tags assigned to the instance.
         */
        public List<Tag> tagSet;

        /**
         * The virtualization type of the instance.
         */
        public String virtualizationType;

        /**
         * The ID of the VPC in which the instance is running.
         */
        public String vpcId;

    }

    /**
     * Describes a block device mapping.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstanceBlockDeviceMapping.html
     */
    public class BlockDeviceMapping {

        /**
         * The device name exposed to the instance (for example, /dev/sdh or xvdh).
         */
        public String deviceName;

        /**
         * Parameters used to automatically set up EBS volumes when the instance is launched.
         */
        public BlockDevice ebs;
    }

    /**
     * Describes a parameter used to set up an EBS volume in a block device mapping.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_EbsInstanceBlockDevice.html
     */
    public class BlockDevice {
        /**
         * The time stamp when the attachment initiated.
         */
        public Datetime attachTime;

        /**
         * Indicates whether the volume is deleted on instance termination.
         */
        public Boolean deleteOnTermination;

        /**
         * The attachment state.
         */
        public String status;

        /**
         * The ID of the EBS volume.
         */
        public String volumeId;

    }

    /**
     * Describes the monitoring for the instance.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Monitoring.html
     */
    public class Monitoring {
        public String state; //disabled
    }

    /**
     * Describes a network interface.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstanceNetworkInterface.html
     */
    public class NetworkInterface {

        /**
         * The association information for an Elastic IP associated with the network interface.
         */
        public NetworkAssociation association;

        /**
         * The network interface attachment.
         */
        public NetworkAttachment attachment;

        /**
         * The description.
         */
        public String description;

        /**
         * One or more security groups.
         */
        public List<SecurityGroup> groupSet;

        /**
         * The MAC address.
         */
        public String macAddress;

        /**
         * The ID of the network interface.
         */
        public String networkInterfaceId;

        /**
         * The ID of the AWS account that created the network interface.
         */
        public String ownerId;

        /**
         * The private DNS name.
         */
        public String privateDnsName;

        /**
         * The IP address of the network interface within the subnet.
         */
        public String privateIpAddress;

        /**
         * The private IP addresses associated with the network interface.
         */
        public List<PrivateIpAddress> privateIpAddressesSet;

        /**
         * Indicates whether to validate network traffic to or from this network interface.
         */
        public Boolean sourceDestCheck;

        /**
         * The status of the network interface.
         */
        public String status;

        /**
         * The ID of the subnet.
         */
        public String subnetId;

        /**
         * The ID of the VPC.
         */
        public String vpcId;

    }


    /**
     * Describes association information for an Elastic IP address.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstanceNetworkInterfaceAssociation.html
     */
    public class NetworkAssociation {

        /**
         * The ID of the owner of the Elastic IP address.
         */
        public String ipOwnerId;

        /**
         * The public DNS name.
         */
        public String publicDnsName;

        /**
         * The public IP address or Elastic IP address bound to the network interface.
         */
        public String publicIp;

    }

    /**
     * Describes a network interface attachment.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstanceNetworkInterfaceAttachment.html
     */
    public class NetworkAttachment {

        /**
         * The ID of the network interface attachment.
         */
        public String attachmentId;

        /**
         * The time stamp when the attachment initiated.
         */
        public Datetime attachTime;

        /**
         * Indicates whether the network interface is deleted when the instance is terminated.
         */
        public Boolean deleteOnTermination;

        /**
         * The index of the device on the instance for the network interface attachment.
         */
        public String deviceIndex;

        /**
         * The attachment state.
         */
        public String status;
    }

    /**
     * Describes a private IP address.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstancePrivateIpAddress.html
     */
    public class PrivateIpAddress {

        /**
         * The association information for an Elastic IP address for the network interface.
         */
        public NetworkAssociation association;

        /**
         * Indicates whether this IP address is the primary private IP address of the network interface.
         */
        public Boolean primary;

        /**
         * Indicates whether this IP address is the primary private IP address of the network interface.
         */
        public String privateDnsName;

        /**
         * privateIpAddress
         */
        public String privateIpAddress;
    }

    /**
     * Describes the placement for the instance.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Placement.html
     */
    public class Placement {

        /**
         * The affinity setting for the instance on the Dedicated host. This parameter is not supported for
         * the ImportInstance command.
         */
        public String Affinity;

        /**
         * The Availability Zone of the instance.
         */
        public String AvailabilityZone;

        /**
         * The name of the placement group the instance is in (for cluster compute instances).
         */
        public String GroupName;

        /**
         * The ID of the Dedicted host on which the instance resides. This parameter is not support for the
         * ImportInstance command.
         */
        public String HostId;

        /**
         * The tenancy of the instance (if the instance is running in a VPC). An instance with a tenancy of
         * dedicated runs on single-tenant hardware. The host tenancy is not supported for the ImportInstance
         * command.
         */
        public String Tenancy;

    }

    /**
     * Describes a product code.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ProductCode.html
     */
    public class ProductCode {

        /**
         * The product code.
         */
        public String productCode;

        /**
         * The type of product code.
         */
        public String type;

    }

    /**
     * Describes the current state of the instance.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstanceState.html
     */
    public class InstanceState {
        /**
         * The low byte represents the state. The high byte is an opaque internal value and should be ignored.
         * - 00 pending
         * - 16 running
         * - 32 shutting-down
         * - 48 terminated
         * - 64 stopping
         * - 80 stopped
         */
        public String code;

        /**
         * The current state of the instance.
         * - pending
         * - running
         * - shutting-down
         * - terminated
         * - stopping
         * - stopped
         */
        public String name;

    }

    /**
     * Describes a state change.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_StateReason.html
     */
    public class Reason {

        /**
         * The reason code for the state change.
         */
        public String code;

        /**
         * The message for the state change.
         */
        public String message;

    }

    /**
     * Describes a tag.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Tag.html
     */
    public class Tag {

        /**
         * The key of the tag.
         */
        public String key;

        /**
         * The value of the tag.
         */
        public String value;
    }

    /**
     * Describes one or more regions that are currently available to you.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeRegions.html
     */
    public class DescribeRegionsResponse {

        /**
         * Information about one or more regions.
         */
        public List<Region> regionInfo;

        /**
         * The ID of the request.
         */
        public String requestId;

    }

    /**
     * Describes a region.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Region.html
     */
    public class Region {

        /**
         * The region service endpoint.
         */
        public String regionEndpoint;

        /**
         * The name of the region.
         */
        public String regionName;

    }

    /**
     * Launches the specified number of instances using an AMI for which you have permissions.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_RunInstances.html
     */
    public class RunInstancesResponse {

        /**
         * The ID of the request.
         */
        public String requestId;

        /**
         * One or more instances.
         */
        public List<Instance> instancesSet;

    }

    /**
     * Shuts down one or more instances.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_TerminateInstances.html
     */
    public class TerminateInstancesResponse {

        /**
         * Information about one or more terminated instances.
         */
        public List<InstanceStateChange> instancesSet;

        /**
         * The ID of the request.
         */
        public String requestId;
    }

    /**
     * Describes an instance state change.
     * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstanceStateChange.html
     */
    public class InstanceStateChange {

        /**
         * The current state of the instance.
         */
        public InstanceState currentState;

        /**
         * The ID of the instance.
         */
        public String instanceId;

        /**
         * The previous state of the instance.
         */
        public InstanceState previousState;

    }

    /**
     * Takes any request object and formats it as query parameters, for example:
     * 
     * DescribeInstancesRequest: [
     *     Filter=(
     *         Filter:[
     *             Name=instance-state-name,
     *             Value=(running)
     *         ]
     *     )
     * ]
     * 
     * &Filter.1.Name=instance-state-name,
     * &Filter.1.Value.1=running
     */
    @TestVisible class RequestFormatter {

        Map<String,String> p = new Map<String,String>();
        List<Object> stack = new List<Object>();

        public RequestFormatter(Object dto) {
            dto = Json.deserializeUntyped(Json.serialize(dto));
            if (dto == null) {
                //nothing to do
            } else if (dto instanceof Map<String,Object>) {
                traverseMap((Map<String,Object>)dto);
            } else if (dto instanceof List<Object>) {
                traverseList((List<Object>)dto);
            } else {
                //nothing to do
            }
        }

        public Map<String,String> getMap() {
            return p;
        }

        void traverseMap(Map<String,Object> dto) {
            List<String> keys = new List<String>(dto.keySet());
            for (String key : keys) {
                stack.add(key);

                Object value = dto.get(key);
                if (value == null) {
                    //nothing to do
                } else if (value instanceof Map<String,Object>) {
                    traverseMap((Map<String,Object>)value);
                } else if (value instanceof List<Object>) {
                    traverseList((List<Object>)value);
                } else {
                    p.put(String.join(stack, '.'), String.valueOf(value));
                }

                stack.remove(stack.size() - 1);
            }
        }

        void traverseList(List<Object> objs) {

            for (Integer i = 0; i < objs.size(); i++) {
                stack.add(i + 1);

                if (objs[i] == null) {
                    //nothing to do
                } else if (objs[i] instanceof Map<String,Object>) {
                    traverseMap((Map<String,Object>)objs[i]);
                } else if (objs[i] instanceof List<Object>) {
                    traverseList((List<Object>)objs[i]);
                } else {
                    p.put(String.join(stack, '.'), String.valueOf(objs[i]));
                }

                stack.remove(stack.size() - 1);
            }

        }

    }
    
    /**
     * Takes any response XML and formats into DTO-ready JSON, for example:
     *
     * <DescribeRegionsResponse>
     *     <requestId>eb34bc90-389f-46c1-81bd-d8492f88983a</requestId>
     *     <regionInfo>
     *         <item>
     *             <regionEndpoint>ec2.us-west-1.amazonaws.com</regionEndpoint>
     *             <regionName>us-west-1</regionName>
     *         </item>
     *     </regionInfo>
     * </DescribeRegionsResponse>
     *
     * {
     *     "requestId": "fff48ea8-2445-492e-a2cf-6bf2582896fb",
     *     "regionInfo": [
     *         {
     *             "regionEndpoint": "ec2.us-west-1.amazonaws.com",
     *             "regionName": "us-west-1"
     *         }
     *     ]
     * }
     */
    @TestVisible class ResponseFormatter {
        
        JsonGenerator g = Json.createGenerator(true);
        
        public ResponseFormatter(Dom.Document document) {
            try {
                g.writeStartObject();
                Dom.XmlNode root = document.getRootElement();
                g.writeFieldName(root.getName());
                traverseNode(root);
                g.writeEndObject();
            } catch (Exception e) {
                e.setMessage(g.getAsString());
                throw e;
            }
        }
        
        public String getJson() {
            String data = g.getAsString();
            data = data.substringAfter(':').substringBeforeLast('}');
            return data;
        }
        
        public void traverseNode(Dom.XmlNode node) {
            
            
            if (!String.isEmpty(node.getName()) && node.getChildren().isEmpty()) {
                //found self closing tag (not text and no children) eg <reason/>
                g.writeNull();
                return;
            }
            
            g.writeStartObject();
            
            for (Dom.XmlNode child : node.getChildren()) {
                
                String name = child.getName();
                String text = child.getText();
                
                if (String.isBlank(name) && String.isBlank(text)) {
                    //found whitespace
                    continue;
                }
                
                if (!String.isBlank(text)) {
                    //found text
                    g.writeFieldName(child.getName());
                    Object value = text;
                    
                    //datetime, boolean, string
                    if (child.getName().endsWith('Time')) value = Json.deserialize('"' + value + '"', Datetime.class);
                    else if (value == 'true') value = true;
                    else if (value == 'false') value = false;
                    g.writeObject(value);
                    
                } else if (name.endsWith('Set') || name.endsWith('Mapping') || name.endsWith('Info') || name.endsWith('Codes')) {
                    //found collection
                    g.writeFieldName(child.getName());
                    g.writeStartArray();
                    for (Dom.XmlNode item : child.getChildElements()) traverseNode(item);
                    g.writeEndArray();
                    
                } else {
                    //found object
                    g.writeFieldName(child.getName());
                    traverseNode(child);
                }
                
            }
            
            g.writeEndObject();
        }
        
    }
    
}