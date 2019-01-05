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
                :renewal_date, :renewal_time,
                :response_data

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

  def initialize(response_data)
    @response_data = response_data

    parse_time!('purchase')
    parse_time!('cancel')
    parse_time!('renewal')

    response_data.each do |key, value|
      underscore = key.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').tr('-', '_').downcase
      send "#{underscore}=", value if VALID_ATTRIBUTES.include?(underscore.to_s.downcase)
    end
  end

  private

    def parse_time!(key_prefix)
      date_key = "#{key_prefix}Date"

      if response_data.has_key?(date_key)
        send("#{key_prefix}_time=", response_data[date_key].nil? ? nil : Time.at(response_data[date_key] / 1000))
      end
    end
end
