package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type donkey struct {
	ID    string `json:"id"`
	Name  string `json:"name"`
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
	id := request.PathParameters["donkey_id"]
	names := map[string]string{
		"1": "Bosse",
		"2": "Uffe",
	}
	resp := donkey{
		ID:   id,
		Name: names[id],
		Links: []link{
			{
				Rel:  "self",
				Href: fmt.Sprintf("%s/donkeys/%s", apiURL, "1"),
			},
			{
				Rel:  "up",
				Href: fmt.Sprintf("%s/donkeys", apiURL),
			},
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
