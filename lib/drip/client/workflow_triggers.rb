module Drip
  class Client
    module WorkflowTriggers
      # Public: List all workflow triggers.
      # id - Required. The String id of the workflow
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#workflow_triggers
      def workflow_triggers(id)
        make_request Drip::Request.new(:get, make_uri("v2/#{account_id}/workflows/#{id}/triggers"))
      end

      # Public: Create a workflow trigger.
      # id - Required. The String id of the workflow
      #
      # options - A Hash of options.
      #           - provider      - Required. Required. A String indicating a provider.
      #           - trigger_type  - Required. A String indicating the automation
      #                             trigger type.
      #           - properties    - Optional. An Object containing properties for the given trigger.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#workflows
      def create_workflow_trigger(id, options = {})
        make_request Drip::Request.new(:post, make_uri("v2/#{account_id}/workflows/#{id}/triggers"), private_generate_resource("triggers", options))
      end

      # Public: Update a workflow trigger.
      # id - Required. The String id of the workflow trigger
      #
      # options - A Hash of options.
      #           - provider      - Required. Required. A String indicating a provider.
      #           - trigger_type  - Required. A String indicating the automation
      #                             trigger type.
      #           - properties    - Optional. An Object containing properties for the given trigger.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#workflows
      def update_workflow_trigger(id, options = {})
        make_request Drip::Request.new(:put, make_uri("v2/#{account_id}/workflows/#{id}/triggers"), private_generate_resource("triggers", options))
      end
    end
  end
end
