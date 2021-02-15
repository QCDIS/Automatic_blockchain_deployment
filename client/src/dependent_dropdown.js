////////////////////////////////////////////////////////////////////
///EC2
////////////////////////////////////////////////////////////////////

const EC2 = [
    {
      "domain": "Virginia",
      "endpoint": "ec2.us-east-1.amazonaws.com",
      "country": "USA",
      "longitude": "78.65 W",
      "latitude": "37.43 N",
      "availability": null,
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 0.5,
          "VMType": "t2.nano",
          "Price": 0.0058,
          "DefaultSSHAccount": "ubuntu",
          "extraInfo": {
            "AMI": "ami-41e0b93b"
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "t2.micro",
          "Price": 0.0116,
          "DefaultSSHAccount": "ubuntu",
          "extraInfo": {
            "AMI": "ami-0565af6e282977273"
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 2,
          "MEM": 4,
          "VMType": "t2.medium",
          "Price": 0.0464,
          "DefaultSSHAccount": "ubuntu",
          "extraInfo": {
            "AMI": "ami-41e0b93b"
          }
        }
      ]
    },
    {
      "domain": "California",
      "endpoint": "ec2.us-west-1.amazonaws.com",
      "country": "USA",
      "longitude": "119.42 W",
      "latitude": "36.78 N",
      "availability": null,
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 0.5,
          "VMType": "t2.nano",
          "Price": 0.0069,
          "DefaultSSHAccount": "ubuntu",
          "extraInfo": {
            "AMI": "ami-79aeae19"
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "t2.micro",
          "Price": 0.0138,
          "DefaultSSHAccount": "ubuntu",
          "extraInfo": {
            "AMI": "ami-09eb5e8a83c7aa890"
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 2,
          "MEM": 4,
          "VMType": "t2.medium",
          "Price": 0.0552,
          "DefaultSSHAccount": "ubuntu",
          "extraInfo": {
            "AMI": "ami-79aeae19"
          }
        }
      ]
    },
    {
      "domain": "Ohio",
      "endpoint": "ec2.us-east-2.amazonaws.com",
      "country": "USA",
      "longitude": "82.90 W",
      "latitude": "40.42 N",
      "availability": null,
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 0.5,
          "VMType": "t2.nano",
          "Price": 0.0058,
          "DefaultSSHAccount": "ubuntu",
          "extraInfo": {
            "AMI": "ami-2581aa40"
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "t2.micro",
          "Price": 0.0116,
          "DefaultSSHAccount": "ubuntu",
          "extraInfo": {
            "AMI": "ami-2581aa40"
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 2,
          "MEM": 4,
          "VMType": "t2.medium",
          "Price": 0.0464,
          "DefaultSSHAccount": "ubuntu",
          "extraInfo": {
            "AMI": "ami-2581aa40"
          }
        }
      ]
    }
  ];





////////////////////////////////////////////////////////////////////
///EXOGENI

///////////////////////////////////////////////////////////////////




const ExoGENI = [
    {
      "domain": "UvA (Amsterdam, The Netherlands) XO Rack",
      "endpoint": "uvanlvmsite.rdf#uvanlvmsite",
      "country": "NLD",
      "longitude": "4.95 E",
      "latitude": "52.36 N",
      "availability": null,
      "extraInfo": {
        "LocalEntry": "https://uva-nl-hn.exogeni.net:11443/orca/xmlrpc"
      },
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "XOSmall",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 10
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 3,
          "VMType": "XOMedium",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 25
          }
        }
      ]
    },
    {
      "domain": "RENCI (Chapel Hill, NC USA) XO Rack",
      "endpoint": "rcivmsite.rdf#rcivmsite",
      "country": "USA",
      "longitude": "79.06 W",
      "latitude": "35.91 N",
      "availability": null,
      "extraInfo": {
        "LocalEntry": "https://rci-hn.exogeni.net:11443/orca/xmlrpc"
      },
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "XOSmall",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 10
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 3,
          "VMType": "XOMedium",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 25
          }
        }
      ]
    },
    {
      "domain": "FIU (Miami, FL USA) XO Rack",
      "endpoint": "fiuvmsite.rdf#fiuvmsite",
      "country": "USA",
      "longitude": "80.19 W",
      "latitude": "25.76 N",
      "availability": null,
      "extraInfo": {
        "LocalEntry": "https://fiu-hn.exogeni.net:11443/orca/xmlrpc"
      },
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "XOSmall",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 10
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 3,
          "VMType": "XOMedium",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 25
          }
        }
      ]
    },
    {
      "domain": "UAF (Fairbanks, AK, USA) XO Rack",
      "endpoint": "uafvmsite.rdf#uafvmsite",
      "country": "USA",
      "longitude": "147.72 W",
      "latitude": "64.84 N",
      "availability": null,
      "extraInfo": {
        "LocalEntry": "https://uaf-hn.exogeni.net:11443/orca/xmlrpc"
      },
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "XOSmall",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 10
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 3,
          "VMType": "XOMedium",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 25
          }
        }
      ]
    },
    {
      "domain": "PSC (Pittsburgh, PA, USA) XO Rack",
      "endpoint": "pscvmsite.rdf#pscvmsite",
      "country": "USA",
      "longitude": "80.00 W",
      "latitude": "40.44 N",
      "availability": null,
      "extraInfo": {
        "LocalEntry": "https://psc-hn.exogeni.net:11443/orca/xmlrpc"
      },
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "XOSmall",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 10
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 3,
          "VMType": "XOMedium",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 25
          }
        }
      ]
    },
    {
      "domain": "UMass (UMass Amherst, MA, USA) XO Rack",
      "endpoint": "umassvmsite.rdf#umassvmsite",
      "country": "USA",
      "longitude": "72.52 W",
      "latitude": "42.37 N",
      "availability": null,
      "extraInfo": {
        "LocalEntry": "https://umass-hn.exogeni.net:11443/orca/xmlrpc"
      },
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "XOSmall",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 10
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 3,
          "VMType": "XOMedium",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 25
          }
        }
      ]
    },
    {
      "domain": "WSU (Detroit, MI, USA) XO Rack",
      "endpoint": "wsuvmsite.rdf#wsuvmsite",
      "country": "USA",
      "longitude": "83.05 W",
      "latitude": "42.33 N",
      "availability": null,
      "extraInfo": {
        "LocalEntry": "https://wsu-hn.exogeni.net:11443/orca/xmlrpc"
      },
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "XOSmall",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 10
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 3,
          "VMType": "XOMedium",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 25
          }
        }
      ]
    },
    {
      "domain": "WVN (UCS-B series rack in Morgantown, WV, USA)",
      "endpoint": "wvnvmsite.rdf#wvnvmsite",
      "country": "USA",
      "longitude": "79.96 W",
      "latitude": "39.63 N",
      "availability": null,
      "extraInfo": {
        "LocalEntry": "https://wvn-hn.exogeni.net:11443/orca/xmlrpc"
      },
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "XOSmall",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 10
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 3,
          "VMType": "XOMedium",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 25
          }
        }
      ]
    },
    {
      "domain": "TAMU (College Station, TX, USA) XO Rack",
      "endpoint": "tamuvmsite.rdf#tamuvmsite",
      "country": "USA",
      "longitude": "96.34 W",
      "latitude": "30.62 N",
      "availability": null,
      "extraInfo": {
        "LocalEntry": "https://tamu-hn.exogeni.net:11443/orca/xmlrpc"
      },
      "VMMetaInfo": [
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 1,
          "VMType": "XOSmall",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 10
          }
        },
        {
          "OS": "Ubuntu 16.04",
          "CPU": 1,
          "MEM": 3,
          "VMType": "XOMedium",
          "Price": null,
          "DefaultSSHAccount": "root",
          "extraInfo": {
            "OS_URL": "http://geni-images.renci.org/images/standard/ubuntu-comet/ubuntu-16.04/ubuntu-16.04.xml",
            "OS_GUID": "564ae072fb3500fa6721c2f976f24fc407e41b5e",
            "DiskSize": 25
          }
        }
      ]
    }
  ];

  

    

// ExoGENI zones
const ExoGENI_zone_array = [];
i=1;
ExoGENI.forEach(function(item){
    ExoGENI_zone_array.push({text: item.domain});
    i++;
});


// EC2 zones
const EC2_zone_array = [];
i=1;
EC2.forEach(function(item){
    EC2_zone_array.push({text: item.domain});
    i++;
});


// ExoGENI os_types and instance types

const ExoGENI_os_type_obj = {};
const ExoGENI_instance_type_obj = {};
ExoGENI.forEach(function(item){
    ExoGENI_os_type_array = []
    test_os_arr = []
    ExoGENI_instance_type_array = []
    test_instance_arr = []
    item.VMMetaInfo.forEach(function(config){
        var os = config.OS
        if (test_os_arr.indexOf(os) === -1) {
            ExoGENI_os_type_array.push({text: config.OS});
            test_os_arr.push(config.OS)
        }
        var vm = config.VMType
        if (test_instance_arr.indexOf(vm) === -1) {
            ExoGENI_instance_type_array.push({text: config.VMType});
            test_instance_arr.push(config.VMType)

        }
    });
    ExoGENI_os_type_obj[item.domain] = ExoGENI_os_type_array
    ExoGENI_instance_type_obj[item.domain] = ExoGENI_instance_type_array
});





exports.ExoGENI_zone_array = ExoGENI_zone_array;
exports.EC2_zone_array = EC2_zone_array;


exports.ExoGENI_os_type_obj = ExoGENI_os_type_obj;
exports.ExoGENI_instance_type_obj = ExoGENI_instance_type_obj;
