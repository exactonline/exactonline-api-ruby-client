require 'spec_helper'

describe "Special Serialization" do
  it "serializes SalesEntryLine gl_account and amount_fc to GLAccount and AmountFC" do
    sales_entry_line = Elmas::SalesEntryLine.new(amount_FC: "23", entry_ID: "23299ask-2233", GL_account: "sdjkj29")
    hash = sales_entry_line.sanitize
    expect(hash).to include("AmountFC")
    expect(hash).to include("GLAccount")
    expect(hash).to include("EntryID")
  end

  it "serializes GLAccounts" do
    params = {
      assimilated_VAT_box: "1",
      exclude_VAT_listing: true,
      private_GL_account: "42",
      VAT_code: "007",
      VAT_GL_account_type: "none",
      VAT_non_deductible_GL_account: "42",
      VAT_non_deductible_percentage: "42",
      VAT_system: "the system",
      year_end_cost_GL_account: "42"
    }
    gl_account = Elmas::GLAccount.new(params)
    hash = gl_account.sanitize
    expect(hash).to include("YearEndCostGLAccount")
    expect(hash).to include("VATSystem")
    expect(hash).to include("VATNonDeductiblePercentage")
    expect(hash).to include("VATNonDeductibleGLAccount")
    expect(hash).to include("VATGLAccountType")
    expect(hash).to include("VATCode")
    expect(hash).to include("PrivateGLAccount")
    expect(hash).to include("AssimilatedVATBox")
    expect(hash).to include("ExcludeVATListing")
  end
end
