package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
    "net/http" // Importación necesaria para realizar solicitudes HTTP
)

func TestTerraformDeployment(t *testing.T) {
    t.Parallel()

    terraformOptions := &terraform.Options{
        TerraformDir: "../terraform-wordpress", // Ruta a los archivos de Terraform
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    instanceIP := terraform.Output(t, terraformOptions, "instance_ip")
    wordpressURL := "http://" + instanceIP

    response, err := http.Get(wordpressURL)
    assert.NoError(t, err)
    assert.Equal(t, 200, response.StatusCode)
}
