module Models
  module Declarable
    extend ActiveSupport::Concern

    included do
      include ApiEntity
      include Models::Formatter

      has_one :section
      has_one :chapter
      has_one :footnote
      has_many :import_measures, class_name: 'Measure'
      has_many :export_measures, class_name: 'Measure'
      has_many :basic_duty_rate_components, class_name: 'MeasureComponent'
      has_many :national_measurement_units, class_name: 'NationalMeasurementUnit'

      attr_accessor :description, :goods_nomenclature_item_id, :producline_suffix, :number_indents, :goods_nomenclature_sid, :bti_url

      format :description_plain, with: DescriptionTrimFormatter,
                                 using: :description
      format :formatted_description, with: DescriptionFormatter,
                                     using: :description

      delegate :numeral, to: :section, prefix: true
      delegate :code, :short_code, to: :chapter, prefix: true
    end

    def code
      goods_nomenclature_item_id
    end
  end
end
