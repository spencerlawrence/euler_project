select *

--jel
from finance.ods_jel_lines_v jel

--adjustments
left join (select line_id, source_id from ds_onecalp.ar_ar_distributions_all) as adjustments_dist on jel.source_distribution_id_num_1 = adjustments_dist.line_id
left join (select adjustment_id, customer_trx_id from ds_onecalp.ar_ar_adjustments_all) as adjustments_adj on adjustments_dist.source_id = adjustments_adj.adjustment_id
left join (select trx_date, trx_number, customer_trx_id from ds_onecalp.ar_ra_customer_trx_all) as adjustments_tran on adjustments_adj.customer_trx_id = adjustments_tran.customer_trx_id

--direct_entries
left join (select pap.segment1, pat.task_number, pat.long_task_name, pap.project_id
             from (select segment1, project_id from ds_onecalp.pa_pa_projects_all) as pap
             left join (select project_id, long_task_name, task_number from ds_onecalp.pa_pa_tasks) as pat on pat.project_id = pap.project_id) direct_entries_p
  on direct_entries_p.task_number = jel.task_cd and direct_entries_p.segment1 = jel.project_cd

--inventory_transactions
left join (select transaction_reference, attribute_category, attribute2, transaction_id, source_project_id, project_id, source_task_id, task_id, to_project_id, to_task_id, transaction_source_type_id, transaction_source_id, transaction_type_id from ds_onecalp.inv_mtl_material_transactions) as inventory_transactions_trns on inventory_transactions_trns.transaction_id = jel.source_id_int_1
left join (select segment1, project_id from ds_onecalp.pa_pa_projects_all) as inventory_transactions_prj on coalesce(inventory_transactions_trns.source_project_id, inventory_transactions_trns.project_id) = inventory_transactions_prj.project_id
left join (select task_number, long_task_name, task_id from ds_onecalp.pa_pa_tasks) as inventory_transactions_tsk on coalesce(inventory_transactions_trns.source_task_id, inventory_transactions_trns.task_id) = inventory_transactions_tsk.task_id
left join (select segment1, project_id from ds_onecalp.pa_pa_projects_all) as inventory_transactions_to_prj on inventory_transactions_trns.to_project_id = inventory_transactions_to_prj.project_id
left join (select task_number, long_task_name, task_id from ds_onecalp.pa_pa_tasks) as inventory_transactions_to_tsk on inventory_transactions_trns.to_task_id = inventory_transactions_to_tsk.task_id
left join (select po_header_id, vendor_id from ds_onecalp.po_po_headers_all) as inventory_transactions_poh on case when (inventory_transactions_trns.transaction_source_type_id = 1) then inventory_transactions_trns.transaction_source_id end = inventory_transactions_poh.po_header_id
left join (select segment1, vendor_name, vendor_id from ds_onecalp.ap_ap_suppliers) as inventory_transactions_pov on inventory_transactions_poh.vendor_id = inventory_transactions_pov.vendor_id
left join (select transaction_type_name, transaction_type_id from ds_onecalp.inv_mtl_transaction_types) as inventory_transactions_mtt on inventory_transactions_mtt.transaction_type_id = inventory_transactions_trns.transaction_type_id

--oxy_po_accrual
left join (select rcv_sub_ledger_id, accounting_event_id from ds_onecalp.po_rcv_receiving_sub_ledger) as oxy_po_accrual_rsb on jel.source_distribution_id_num_1 = oxy_po_accrual_rsb.rcv_sub_ledger_id
left join (select accounting_event_id, po_distribution_id from ds_onecalp.po_rcv_accounting_events) as oxy_po_accrual_rae on oxy_po_accrual_rsb.accounting_event_id = oxy_po_accrual_rae.accounting_event_id
left join (select attribute2, po_distribution_id, po_header_id, task_id, project_id from ds_onecalp.po_po_distributions_all) as oxy_po_accrual_pda on oxy_po_accrual_rae.po_distribution_id = oxy_po_accrual_pda.po_distribution_id
left join (select po_header_id, vendor_id from ds_onecalp.po_po_headers_all) as oxy_po_accrual_poh on oxy_po_accrual_pda.po_header_id = oxy_po_accrual_poh.po_header_id
left join (select segment1, vendor_name, vendor_id from ds_onecalp.ap_ap_suppliers) as oxy_po_accrual_pov on oxy_po_accrual_poh.vendor_id = oxy_po_accrual_pov.vendor_id
left join (select task_number, long_task_name, task_id from ds_onecalp.pa_pa_tasks) as oxy_po_accrual_pt on oxy_po_accrual_pda.task_id = oxy_po_accrual_pt.task_id
left join (select segment1, project_id from ds_onecalp.pa_pa_projects_all) as oxy_po_accrual_ppa on oxy_po_accrual_pda.project_id = oxy_po_accrual_ppa.project_id

--payables
left join (select description, invoice_date, invoice_id, invoice_num, source, vendor_id from ds_onecalp.ap_ap_invoices_all) as payables_invs on payables_invs.invoice_id = jel.source_id_int_1
left join (select segment1, vendor_id, vendor_name from ds_onecalp.ap_ap_suppliers) as payables_vend on payables_vend .vendor_id = payables_invs.vendor_id
left join (select attribute2, attribute8, description, invoice_distribution_id, po_distribution_id, project_id, task_id from ds_onecalp.ap_ap_invoice_distributions_all) as payables_idstr on jel.source_distribution_id_num_1 = payables_idstr.invoice_distribution_id
left join (select attribute2, po_distribution_id from ds_onecalp.po_po_distributions_all) as payables_pdstr on payables_idstr.po_distribution_id = payables_pdstr.po_distribution_id
left join (select project_id, segment1 from ds_onecalp.pa_pa_projects_all) as payables_proj on payables_idstr.project_id = payables_proj.project_id
left join (select long_task_name, task_id, task_number from ds_onecalp.pa_pa_tasks) as payables_task on payables_idstr.task_id = payables_task.task_id

--payments
left join (select check_date, check_id, check_number, vendor_id from ds_onecalp.ap_ap_checks_all) as payments_apc on jel.source_id_int_1 = payments_apc.check_id
left join (select segment1, vendor_id, vendor_name from ds_onecalp.ap_ap_suppliers) as payments_vend on payments_vend.vendor_id = payments_apc.vendor_id
left join (select payment_hist_dist_id, invoice_distribution_id from ds_onecalp.ap_ap_payment_hist_dists) as payments_pdstr on jel.source_distribution_id_num_1 = payments_pdstr.payment_hist_dist_id
left join (select attribute2, attribute8, invoice_distribution_id, invoice_id, project_id, task_id from ds_onecalp.ap_ap_invoice_distributions_all) as payments_idstr on payments_pdstr.invoice_distribution_id = payments_idstr.invoice_distribution_id
left join (select invoice_date, invoice_id, invoice_num from ds_onecalp.ap_ap_invoices_all) as payments_invs on payments_invs.invoice_id = payments_idstr.invoice_id
left join (select long_task_name, task_id, task_number from ds_onecalp.pa_pa_tasks) as payments_task on payments_idstr.task_id = payments_task.task_id
left join (select project_id, segment1 from ds_onecalp.pa_pa_projects_all) as payments_proj on payments_idstr.project_id = payments_proj.project_id

--projects
left join (select expenditure_item_id, line_num from ds_onecalp.pa_pa_cost_distribution_lines_all) as projects_cdist on jel.source_distribution_id_num_1 = projects_cdist.expenditure_item_id and jel.source_distribution_id_num_2 = projects_cdist.line_num
left join (select attribute2, expenditure_id, expenditure_item_id, task_id from ds_onecalp.pa_pa_expenditure_items_all) as projects_expi on projects_expi.expenditure_item_id = projects_cdist.expenditure_item_id
left join (select expenditure_group, expenditure_id, vendor_id from ds_onecalp.pa_pa_expenditures_all) as projects_exp on projects_expi.expenditure_id = projects_exp.expenditure_id
left join (select segment1, vendor_id, vendor_name from ds_onecalp.ap_ap_suppliers) as projects_pov on projects_pov.vendor_id = projects_exp.vendor_id
left join (select expenditure_comment, expenditure_item_id from ds_onecalp.pa_pa_expenditure_comments) as projects_expc on projects_expc.expenditure_item_id = projects_expi.expenditure_item_id
left join (select long_task_name, task_id, task_number, project_id from ds_onecalp.pa_pa_tasks) as projects_pat on projects_pat.task_id = projects_expi.task_id
left join (select project_id, segment1 from ds_onecalp.pa_pa_projects_all) as projects_pap on projects_pat.project_id = projects_pap.project_id

--sales_invoices
left join (select cust_trx_line_gl_dist_id, customer_trx_id from ds_onecalp.ar_ra_cust_trx_line_gl_dist_all) as sales_invoices_dist on jel.source_distribution_id_num_1 = sales_invoices_dist.cust_trx_line_gl_dist_id
left join (select trx_date, trx_number, customer_trx_id from ds_onecalp.ar_ra_customer_trx_all) as sales_invoices_tran on sales_invoices_tran.customer_trx_id = sales_invoices_dist.customer_trx_id