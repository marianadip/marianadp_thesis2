# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: public.order_items ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: gross_margin {
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  measure: total_gross_margin {
    label: "Total Gross Margin"
    type: sum
    value_format_name: usd
    sql: ${gross_margin} ;;
  }

  measure: total_gross_margin_percentage {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${total_gross_margin}/ NULLIF(${total_sale_price},0) ;;
  }


  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.
  measure: total_revenue  {
    type: sum
    sql: ${sale_price} ;;
    value_format: "$#,##0.00"
  }
  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }

  parameter: metric_selector {
    type: string
    allowed_value: {
      label: "Total Gross Margin"
      value: "total_gross_margin"
    }
    allowed_value: {
      label: "Total sale price"
      value: "total_sale_price"
    }
    allowed_value: {
      label: "Total gross margin percentage"
      value: "total_gross_margin_percentage"
    }
  }

  measure: metric {
    label_from_parameter: metric_selector
    label: "Totals metric"
    type: number
    #value_format: "$0.0,\"K\""
    sql:
      CASE
      WHEN {% parameter metric_selector %} = 'total_gross_margin' THEN ${total_gross_margin}
      WHEN {% parameter metric_selector %} = 'total_sale_price' THEN ${total_sale_price}
      WHEN {% parameter metric_selector %} = 'total_gross_margin_percentage' THEN ${total_gross_margin_percentage}
      ELSE NULL
    END ;;
  }

}
