with controls (
    control_id,
    control_name,
    control_area,
    expected_frequency,
    severity,
    owner_group
) as (
    values
    ('fin_ctrl_001', 'Order total to item total reconciliation', 'orders', 'per_build', 'high', 'finance'),
    ('fin_ctrl_002', 'Recipe cost variance review', 'margin', 'daily', 'medium', 'finance'),
    ('fin_ctrl_003', 'Refund and concession reason review', 'refunds', 'weekly', 'medium', 'finance')
)

select
    control_id,
    control_name,
    control_area,
    expected_frequency,
    severity,
    owner_group
from controls
