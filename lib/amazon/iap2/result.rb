require "json"

class Amazon::Iap2::Result
  attr_accessor :product_type, :product_id, :parent_product_id,
                :purchase_date, :purchase_time,
                :cancel_date, :cancel_time,
                :receipt_id,
                :quantity,
                :test_transaction,
                :beta_product,
                :term, :term_sku,
                :renewal_date, :renewal_time

    VALID_ATTRIBUTES = %w(
      product_type
      product_id
      parent_product_id
      purchase_date
      purchase_time
      cancel_date
      cancel_time
      receipt_id
      quantity
      test_transaction
      beta_product
      term
      term_sku
      renewal_date
      renewal_time
    )

  def initialize(receipt_data)
    parse_time!(receipt_data, 'purchase')
    parse_time!(receipt_data, 'cancel')
    parse_time!(receipt_data, 'renewal')

    receipt_data.each do |key, value|
      underscore = key.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').tr('-', '_').downcase
      send "#{underscore}=", value if VALID_ATTRIBUTES.include?(underscore.to_s.downcase)
    end
  end

  private

    def parse_time!(json, date_key_prefix)
      date_key = "#{date_key_prefix}Date"
      time_key = "#{date_key_prefix}Time"

      if json.has_key?(date_key)
        json[time_key] = json[date_key].nil? ? nil : Time.at(json[date_key] / 1000)
      end
    end
end
