require_relative "spec_helper"
require "api_example"

describe ApiExample do

  let(:example) { ApiExample.new(host, data) }
  let(:host) { "example.org" }
  let(:data) { {request: request, response: response} }
  let(:request) { {} }
  let(:response) { {} }

  describe "#http_request" do

    let(:request_lines) { example.http_request.split("\n") }

    describe "with only a verb and path" do
      let(:request) { {verb: "GET", path: "/some/path"} }

      it "begins with the HTTP request" do
        request_lines.first.must_equal "GET /some/path HTTP/1.1"
      end

      it "contains Host header" do
        request_lines.must_include "Host: example.org"
      end

      it "does not have Content-Type header" do
        request_lines.any? { |line| line =~ /Content-Type:/ }.must_equal false
      end
    end

    describe "with request data" do
      let(:request) { {verb: "POST", path: "/path", data: {}} }

      it "includes a Content-Type header" do
        request_lines.must_include(
          "Content-Type: application/json; charset=utf-8"
        )
      end
    end

    describe "with request headers" do
      let(:headers) do
        {
          "X-Header" => "one two",
          "Header-Two" => "three",
        }
      end
      let(:request) { {verb: "POST", path: "/", headers: headers} }

      it "contains headers" do
        request_lines[1..-1].must_include "X-Header: one two"
        request_lines[1..-1].must_include "Header-Two: three"
      end
    end

    describe "PATCH request" do
      let(:request) { {verb: "PATCH", path: "/path"} }

      it "replaces verb with POST" do
        request_lines.first.must_equal("POST /path HTTP/1.1")
      end

      it "sets X-Http-Method-Override: PATCH" do
        request_lines.must_include("X-Http-Method-Override: PATCH")
      end
    end

  end

  describe "#http_response" do

    let(:response_lines) { example.http_response.split("\n") }

    describe "with a 204 No Content response" do
      let(:response) { {status: 204} }

      it "begins with 204 No Content line" do
        response_lines.first.must_equal("HTTP/1.1 204 No Content")
      end

      it "contains no blank line" do
        response_lines.any? { |line| line == "" }.must_equal false
      end
    end

    describe "with a 200 OK JSON response" do
      let(:data) do
        {
          response: {
            status: 200,
            headers: {
              "Content-Type" => "application/json"
            },
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

    describe "with a suppressed X-Runtime header" do
      let(:response) do
        {
          status: 200,
          headers: {
            "X-Not-Filtered" => "keep me",
            "X-Runtime" => "0.123",
          }
        }
      end
      it "removes X-Runtime header" do
        response_lines.wont_include("X-Runtime: 0.123")
      end
      it "does not remove other headers" do
        response_lines.must_include("X-Not-Filtered: keep me")
      end
    end

  end

end
