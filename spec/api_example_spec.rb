require "minitest/autorun"
require "minitest/spec"
require "turn"

require_relative "../lib/api_example"

describe ApiExample do

  let(:example) { ApiExample.new(host, data) }
  let(:data) { {} }
  let(:host) { "example.org" }

  describe "#http_request" do

    describe "with only an action" do
      let(:data) { {action: "GET /some/path"} }

      it "returns the action and auth header" do
        example.http_request.must_equal(
          "GET /some/path HTTP/1.1\n" +
          "Host: example.org\n" +
          "Authorization: Bearer USER_ACCESS_TOKEN"
        )
      end
    end

    describe "with authorization false" do
      let(:data) { {action: "GET /some/path", authorization: false} }

      it "returns the action and auth header" do
        example.http_request.must_equal(
          "GET /some/path HTTP/1.1\n" +
          "Host: example.org"
        )
      end
    end

    describe "with parameters" do
      let(:data) { {action: "POST /path", parameters: [{key: "", type: ""}]} }

      it "includes a Content-Type header" do
        example.http_request.split("\n").must_include(
          "Content-Type: application/json; charset=utf-8"
        )
      end
    end

  end

  describe "#http_response" do

    let(:response_lines) { example.http_response.split("\n") }

    describe "with a 204 No Content response" do
      let(:data) { {response: {status: 204}} }

      it "begins with 204 No Content line" do
        response_lines.first.must_equal("HTTP/1.1 204 No Content")
      end
    end

    describe "with a 200 OK JSON response" do
      let(:data) do
        {
          response: {
            status: 200,
            content_type: "application/json",
          }
        }
      end

      it "begins with 200 OK" do
        response_lines.first.must_equal("HTTP/1.1 200 OK")
      end

      it "contains Content-Type: application/json header" do
        response_lines.must_include "Content-Type: application/json"
      end
    end

  end

end
