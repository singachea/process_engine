module ProcessEngine
  class ProcessDefinition < ActiveRecord::Base
    has_many :process_instances, dependent: :destroy
    validates :name, presence: true
    validates :slug, presence: true, uniqueness: true

    scope :desc, -> { order('id desc') }
    scope :asc, -> { order('id asc') }

    before_save :update_json_from_xml
    before_save :update_starting_node
    validate :check_xml_format


    def schema
      ProcessEngine::ProcessSchema.new(self)
    end

    private

    def update_json_from_xml
      return unless bpmn_xml_changed?
      doc  = Nokogiri::XML(bpmn_xml)
      process = doc.at_xpath('//bpmn2:process') rescue nil

      return unless process.present?
      elements = process.elements.map{ |el| ProcessEngine::Parser::XmlNode.factory(el) }.compact

      graph = elements.each_with_object({nodes: [], transitions: []}) do |el, hash|
        unless el.type_flow?
          hash[:nodes] << el.to_h
        else
          hash[:transitions] << el.to_h
        end
      end

      self.bpmn_json = graph
    end

    def update_starting_node
      starter_node = schema.nodes_by_type(ProcessEngine::Schema::Node::NodeType::START_EVENT).first
      self.starting_node = starter_node.node_id if starter_node
    end

    def check_xml_format
      doc = Nokogiri.XML(bpmn_xml)
      errors.add(:bpmn_xml, 'is invalid') if bpmn_xml.present? && (doc.errors.count > 0 || (doc.at_xpath('//bpmn2:process') rescue nil).nil?)
    end
  end
end
