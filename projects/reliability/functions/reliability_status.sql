case
    when reliability_score < 0.60 then 'critical'
    when reliability_score < 0.80 then 'watch'
    else 'stable'
end
