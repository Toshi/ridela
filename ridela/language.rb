
module Ridela
  class Language
    def root() @scope.first; end
    def that() @scope.last; end
    def depth() @scope.size; end

    def initialize(root)
      @scope = [root]
    end
    
    def args(*arg_list)
      arg_list.each do |a|
        arg(*a)
      end
    end
    
    def define(block)
      block.call(self)
    end
   
    def define_with(topush, annotations, block=nil)
      annotations.each { |k,v| topush[k] = v }
      @scope.push(topush)
      begin
        define(block) if block
      ensure
        @scope.pop
        @scope.last.add(topush)
      end
      topush
    end
    
    def interface(name, annot={}, &block) define_with(InterfaceNode.new(name), annot, block); end
    def method(name, annot={}, &block) define_with(MethodNode.new(name), annot, block); end
    def arg(name, type, annot={}) define_with(ArgNode.new(name, type), annot); end

    def annotate(key, val)
      @scope.last[key] = val
    end
  end
  
  def self.namespace(name="", &block)
    l = Language.new(NamespaceNode.new(name))
    l.define(block) if block_given?
    l.root
  end
end
