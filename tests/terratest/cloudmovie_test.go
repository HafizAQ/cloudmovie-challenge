package test

import (
	"io"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestCloudMovieHealthEndpoint(t *testing.T) {

	options := &terraform.Options{
		TerraformDir: "../../infrastructure/environments/dev",
	}

	albDNS := terraform.Output(
		t,
		options,
		"alb_dns_name",
	)

	if albDNS == "" {
		t.Fatal("alb_dns_name output is empty")
	}

	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	response, err := client.Get(
		"http://" + albDNS + "/health",
	)

	if err != nil {
		t.Fatalf(
			"failed calling health endpoint: %v",
			err,
		)
	}

	defer response.Body.Close()

	if response.StatusCode != http.StatusOK {
		t.Fatalf(
			"expected 200, got %d",
			response.StatusCode,
		)
	}

	body, err := io.ReadAll(response.Body)

	if err != nil {
		t.Fatal(err)
	}

	if !strings.Contains(
		string(body),
		"healthy",
	) {
		t.Fatalf(
			"unexpected response: %s",
			string(body),
		)
	}
}