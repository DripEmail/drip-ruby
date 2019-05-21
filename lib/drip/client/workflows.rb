require "cgi"

module Drip
  class Client
    module Workflows
      # Public: List all workflows.
      #
      # options - A Hash of options
      #           - status - Optional. Filter by one of the following statuses:
      #                      draft, active, or paused. Defaults to all.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#workflows
      def workflows(options = {})
        make_json_api_request :get, "v2/#{account_id}/workflows", options
      end

      # Public: Fetch a workflow.
      # id - Required. The String id of the workflow
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#workflows
      def workflow(id)
        make_json_api_request :get, "v2/#{account_id}/workflows/#{id}"
      end

      # Public: Activate a workflow.
      # id - Required. The String id of the workflow
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#workflows
      def activate_workflow(id)
        make_json_api_request :post, "v2/#{account_id}/workflows/#{id}/activate"
      end

      # Public: Pause a workflow.
      # id - Required. The String id of the workflow
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#workflows
      def pause_workflow(id)
        make_json_api_request :post, "v2/#{account_id}/workflows/#{id}/pause"
      end

      # Public: Start someone on a workflow.
      # id - Required. The String id of the workflow
      #
      # options - A Hash of options.
      #           - email         - Optional. A new email address for the subscriber.
      #                             If provided and a subscriber with the email above
      #                             does not exist, this address will be used to
      #                             create a new subscriber.
      #           - id            - Optional. The subscriber's Drip id. Either email or id must be included.
      #           - user_id       - Optional. A unique identifier for the user in your database,
      #                             such as a primary key.
      #           - time_zone     - Optional. The subscriber's time zone (in Olson
      #                             format). Defaults to Etc/UTC.
      #           - custom_fields - Optional. A Hash of custom field data.
      #           - tags          - Optional. An Array of tags.
      #           - prospect      - Optional. A Boolean specifiying whether we should attach a lead
      #                             score to the subscriber (when lead scoring is enabled). Defaults to true
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#workflows
      def start_subscriber_workflow(id, options = {})
        make_json_api_request :post, "v2/#{account_id}/workflows/#{id}/subscribers", private_generate_resource("subscribers", options)
      end

      # Public: Remove someone from a workflow.
      # id          - Required. The String id of the workflow
      # id_or_email - Required. The String id or email address of the subscriber.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#workflows
      def remove_subscriber_workflow(workflow_id, id_or_email)
        make_json_api_request :delete, "v2/#{account_id}/workflows/#{workflow_id}/subscribers/#{CGI.escape id_or_email}"
      end
    end
  end
end
