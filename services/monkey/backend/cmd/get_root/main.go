package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type response struct {
	Links []link `json:"links"`
}

type link struct {
	Rel  string `json:"rel"`
	Href string `json:"href"`
}

func handler(
	ctx context.Context,
	request events.APIGatewayProxyRequest,
) (
	events.APIGatewayProxyResponse,
	error,
) {
	apiURL := os.Getenv("API_URL")
	var resp response
	resp.Links = []link{
		{
			Rel:  "self",
			Href: apiURL,
		},
		{
			Rel:  "monkeys",
			Href: fmt.Sprintf("%s/monkeys", apiURL),
		},
	}

	body, _ := json.Marshal(resp)
	return events.APIGatewayProxyResponse{
		Body:       string(body),
		Headers:    map[string]string{"Access-Control-Allow-Origin": "*"},
		StatusCode: 200,
	}, nil
}

func main() {
	lambda.Start(handler)
}
