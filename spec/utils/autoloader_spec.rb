# frozen_string_literal: true

require "utils/autoloader"
require "utils/strings"

RSpec.describe HaveIBeenPwnedApi::Utils::Autoloader do
  describe ".define_endpoint_methods" do
    context "when module has a class with a .call method defined" do
      it "defines a module level class method with the snake-cased class name" do
        klass = Class.new do
          def self.call; end
        end

        test_mod = Module.new
        test_mod.const_set("ClassWithCall", klass)

        stub_const("TestModule", test_mod)

        described_class.define_endpoint_methods(TestModule)

        expect(TestModule.respond_to?(:class_with_call)).to eq(true)
      end
    end

    context "when module has a class that does not have .call method defined" do
      it "raises an error" do
        klass = Class.new
        test_mod = Module.new
        test_mod.const_set("ClassWithoutCall", klass)

        stub_const("TestModule", test_mod)

        expect { described_class.define_endpoint_methods(TestModule) }
          .to raise_error(HaveIBeenPwnedApi::Error)
      end
    end

    context "when module has a nested module defined" do
      it "does not raise an error and does not create a method" do
        test_mod = Module.new
        nested_test_mod = Module.new
        test_mod.const_set("NestedModule", nested_test_mod)

        stub_const("TestModule", test_mod)

        expect { described_class.define_endpoint_methods(TestModule) }
          .to_not raise_error(HaveIBeenPwnedApi::Error)
        expect(TestModule.respond_to?(:nested_module)).to eq(false)
      end
    end
  end
end
