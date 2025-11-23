package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// TestModuleValidates ensures the module compiles correctly
func TestModuleValidates(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			// Supply dummy values for all required variables
			"workspace_name": "test-ws",
			"location":       "eastus",
		},
	}

	// Just check if module is valid and Terraform can parse variables
	terraform.InitAndValidate(t, terraformOptions)
}

// TestMissingRequiredVariable ensures Terraform errors if required variables are missing
func TestMissingRequiredVariable(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		// Intentionally omit required variables
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	if err == nil {
		t.Fatal("Expected Terraform to fail due to missing required variables, but plan succeeded")
	}
}

// TestVariableValidation ensures variable validation blocks work
func TestVariableValidation(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			// Provide invalid value to trigger validation block
			"workspace_name": "",
			"location":       "eastus",
		},
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	if err == nil {
		t.Fatal("Expected Terraform validation to fail for invalid workspace_name, but plan succeeded")
	}
}
