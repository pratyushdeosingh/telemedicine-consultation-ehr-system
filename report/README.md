# Technical report

[Read the final report](DBMS_Project_Report.pdf) (36 pages).

See also the [database design](../docs/README.md), [test results](../tests/README.md) and [screenshots](../screenshots/README.md).

## Implementation clarifications

The supplied PDF is preserved unchanged. Two descriptions should be read alongside the implemented SQL:

- Page 24 mentions a consultation fee in invoice calculation. `CALCULATE_INVOICE_TOTAL` sums medicine quantities at current catalog prices and ordered laboratory charges; it excludes consultation fees, as noted on page 33.
- Page 13 labels appointment-to-session, appointment-to-prescription and appointment-to-invoice relationships as `1:0..1`. Their composite primary keys allow multiple child rows per appointment; the API rejects duplicate invoices in its creation workflow. See the [relational schema](../docs/relational-schema.md).

Cassandra scalability is a design motivation; this prototype does not establish measured scaling or multi-node failover.
