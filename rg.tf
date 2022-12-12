resource "aws_resourcegroups_group" "instance" {
  name = "instance"

  resource_query {
    query = <<JSON
      {
        "ResourceTypeFilters": [
          "AWS::EC2::Instance"
        ],
        "TagFilters": [
          {
            "Key": "Name",
            "Values": [
              "NeboInstance"
            ]
          }
        ]
      }
JSON
  }
}