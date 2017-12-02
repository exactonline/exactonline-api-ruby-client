require 'spec_helper'

describe Elmas::Utils do
  it "camelizes a string" do
    expect(Elmas::Utils.camelize("a_class_boom")).to eq "AClassBoom"
  end

  it "camelizes a string with first letter downcase" do
    expect(Elmas::Utils.camelize("a_class_boom", false)).to eq "aClassBoom"
  end

  it "demodulizes a class name in a module" do
    expect(Elmas::Utils.demodulize("Module::Class")).to eq "Class"
  end

  it "pluralizes a word" do
    expect(Elmas::Utils.pluralize("Book")).to eq "Books"
  end

  it "doesn't double pluralize books to bookss" do
    expect(Elmas::Utils.pluralize("Books")).to eq "Books"
  end

  it "shows a collection path of a class name" do
    expect(Elmas::Utils.collection_path("Exact::User")).to eq "users"
  end

  let(:original_hash) do
    {
      "Module::Foo" => "bar",
      "module::class" => "bar",
      "ModuleOne::ClassTwo" => "bar"
    }
  end

  let(:normalized_hash) do
    {
      :"module/foo" => "bar",
      :"module/class" => "bar",
      :"module_one/class_two" => "bar"
    }
  end

  it "normalizes a hash" do
    expect(Elmas::Utils.normalize_hash(original_hash)).to eq(normalized_hash)
  end

  it "normalizes attributes correctly" do
    expect(Elmas::Utils.normalize_hash({ "AmountFC" => "blaa" })).to eq({ amount_FC: "blaa" })
  end
end
