require 'rails_helper'

RSpec.describe ErrorSerializer do
  before:each do
    @error_object = double("ErrorObject", status_code: 422, message: "Invalid attribute")
    @serializer = ErrorSerializer.new(@error_object)
    @serialized_error = @serializer.serialize_json
  end

  describe '#serialize_json' do
    it "includes a message that the query could not be completed" do
      expect(@serialized_error[:message]).to eq("your query could not be completed")
    end

    it "errors are in an array" do
      expect(@serialized_error[:errors]).to be_an(Array)
    end

    it "contains one error with the correct status and title" do
      expect(@serialized_error[:errors].size).to eq(1)
      expect(@serialized_error[:errors][0][:status]).to eq("422")
      expect(@serialized_error[:errors][0][:title]).to eq("Invalid attribute")
    end
  end
end
