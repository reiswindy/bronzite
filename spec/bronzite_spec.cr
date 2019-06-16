require "./spec_helper"

describe Bronzite do
  # TODO: Write tests

  it "works" do
    client = Bronzite.parse(SpecHelper::Samples["billservice.wsdl"])
    client.functions.should eq({
      "getStatus" => "getStatusResponse getStatus(getStatus parameters)",
      "sendBill" => "sendBillResponse sendBill(sendBill parameters)",
      "sendPack" => "sendPackResponse sendPack(sendPack parameters)",
      "sendSummary" => "sendSummaryResponse sendSummary(sendSummary parameters)"
    })
  end
end
