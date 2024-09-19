locals {
  anti-pattern-regex = "/[//\"'\\[\\]:|<>+=;,?*@&]/"
  asv-name = replace("${var.env}-${var.group}-${var.project}-${var.userDefinedString}-asv", local.anti-pattern-regex, "")
}