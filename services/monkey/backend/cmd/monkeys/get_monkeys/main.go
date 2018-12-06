package main

import (
	"context"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler(
	ctx context.Context,
	request events.APIGatewayProxyRequest,
) (
	events.APIGatewayProxyResponse,
	error,
) {
	return events.APIGatewayProxyResponse{
		Body:       `[{"id": "1", "name": "Bosse"}, {"id": "2", "name": "Uffe"}]`,
		StatusCode: 200,
	}, nil
}

func main() {
	lambda.Start(handler)
}
