resource "aws_cloudtrail" "cloudtrail-logging" {
  name                          = "cloudtrail-logging"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrail-s3bucket.id}"
  s3_key_prefix                 = "prefix"
  include_global_service_events = "${var.CLOUDTRAIL_INCLUDE_GLOBAL_SERVICE_EVENTS}"
  is_multi_region_trail         = "${var.CLOUDTRAIL_IS_MULTI_REGION}"
}

resource "aws_s3_bucket" "cloudtrail-s3bucket" {
  bucket        = "cloudtrail-${var.DEFAULT_ROUTE53_ZONE}"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::cloudtrail-${var.DEFAULT_ROUTE53_ZONE}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::cloudtrail-${var.DEFAULT_ROUTE53_ZONE}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
