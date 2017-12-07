#!/bin/bash

# generate yaml invoice

DATE_STAMP=$(date "+%Y%m%d")

echo $1 > invoice_${DATE_STAMP}_$$.yaml--- !urbanspectra/^invoice
invoice: 0001
date       : ${DATE_STAMP}
sold-by    : ${SELLER}
bill-to: ${BILL2_ID}
    given  : ${FNAME}
    family : ${LNAME}
    address:
        lines: |
            ${ADDR_LINE_2}
            ${ADDR_LINE_2}
        city    : ${}CITY
        state   : ${MI}
        postal  : ${ZIP}
ship-to: ${SHIP2_ID}
product: # ??  How to iterate through multiple items else services.
    - sku         : ${SKU}
      quantity    : ${COUNT}
      description : ${NAME}
      price       : ${PRICE}
subtotal: ${SUBTOTAL}
tax  : ${TAX}
total: ${TOTAL}
comments: >
    ${NOTES}
    