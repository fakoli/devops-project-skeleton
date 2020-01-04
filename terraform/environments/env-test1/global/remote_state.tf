terraform {
    backend "remote" {
        organization = "fakoli"
        workspaces {
            name = "env-test1-global"
        }
    }
}