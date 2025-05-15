locals {
  cert_url = strcontains(var.env, "G3") ? "https://g3pceslzresentdfa0353e.blob.core.windows.net/publicresources/GOC-GDC-ROOT-A.crt" : "https://gcpcenteslzpublicblob4df.blob.core.windows.net/publicresources/GOC-GDC-ROOT-A.crt" 
}

data "http" "cert" {
  count = try(var.appServiceLinux.inject_root_cert, false) ? 1 : 0
  url = local.cert_url
}