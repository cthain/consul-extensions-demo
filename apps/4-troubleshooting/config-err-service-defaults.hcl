Kind = "service-defaults"
Name = "api"
Protocol = "http"
EnvoyExtensions = [
  {
    Name      = "builtin/ext-authz"
    Arguments = {
      Config = {
        GrpcService = {
          Target = {
            URI = "127.0.0.1:9191"
          }
        },
        HttpService = {
          Target = {
            URI = "127.0.0.1:9191"
          }
        }
      }
    }
  },
  {
    Name      = "builtin/wasm"
    Arguments = {
      Protocol = "http"
      ListenerType = "inbound"
      PluginConfig = {
        VmConfig = {
          Code = {
            Local = {
              Filename = "coraza-proxy-wasm.wasm"
            },
            Remote = {
              HttpURI = {
                Service = {
                  Name = "file-server"
                }
                URI = "https://file-server/coraza-proxy-wasm.wasm"
              SHA256 = "cd4fe769d324e3499ba537c5a53c77591423737745b39c6e894a0a2693f7e21c"
              }
            }
          }
        },
        Configuration = <<EOC
{
  "directives_map": {
    "default": [
      "Include @demo-conf",
      "Include @crs-setup-demo-conf",
      "Include @owasp_crs/*.conf",
      "SecDebugLogLevel 9",
      "SecRuleEngine On"
    ]
  },
  "default_directives": "default"
}
EOC
      }
    }
  }
]
