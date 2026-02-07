# frozen_string_literal: true

require_relative "base"

module Authensure
  module Resources
    class Teams < Base
      def list_members
        response = http.get("/teams/members")
        response.map { |m| symbolize_keys(m) }
      end

      def get_member(member_id)
        response = http.get("/teams/members/#{member_id}")
        symbolize_keys(response)
      end

      def invite(email:, role: "member", **options)
        body = { email: email, role: role }.merge(options)
        response = http.post("/teams/invite", body)
        symbolize_keys(response)
      end

      def cancel_invitation(invitation_id)
        http.delete("/teams/invitations/#{invitation_id}")
        true
      end

      def resend_invitation(invitation_id)
        response = http.post("/teams/invitations/#{invitation_id}/resend")
        symbolize_keys(response)
      end

      def update_member_role(member_id, role:)
        response = http.patch("/teams/members/#{member_id}", { role: role })
        symbolize_keys(response)
      end

      def remove_member(member_id)
        http.delete("/teams/members/#{member_id}")
        true
      end

      def suspend_member(member_id)
        response = http.post("/teams/members/#{member_id}/suspend")
        symbolize_keys(response)
      end

      def reactivate_member(member_id)
        response = http.post("/teams/members/#{member_id}/reactivate")
        symbolize_keys(response)
      end

      def list_invitations
        response = http.get("/teams/invitations")
        response.map { |i| symbolize_keys(i) }
      end

      def accept_invitation(token)
        response = http.post("/teams/invitations/accept", { token: token })
        symbolize_keys(response)
      end
    end
  end
end
