view: PoP {
  derived_table: {
    explore_source: order_items {


      column: id {
        field: order_items.id
      }

      column: order_id {
        field: order_items.order_id
      }

      column: created_at{
        field: inventory_items.created_raw
      }

      column: count{
        field: order_items.count
      }

    #  column: order_count{
     #   field: order_items.order_count
      #}

      column: sale_price{
        field: order_items.sale_price
      }

      column: total_sale_price{
        field: order_items.total_sale_price
      }

    }
  }
  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }


  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: sale_price {
    type: number
    value_format_name: usd
    hidden: yes
    sql: ${TABLE}.sale_price ;;
  }


  measure: count {
    label: "Count of order_items"
    type: count
    hidden: yes
  }
 # measure: order_count {
  #  label: "Count of orders"
   # type: count_distinct
    #sql: ${order_count} ;;
    #hidden: yes
  #}

  measure: total_sale_price {
    label: "Total Sales"
    view_label: "PoP"
    type: sum
    value_format_name: decimal_0
    sql:coalesce(${sale_price},0) ;;
    drill_fields: [created_date]
  }
}
