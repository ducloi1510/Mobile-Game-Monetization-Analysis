-- ============================================
--Tạo các bảng 
-- ============================================
CREATE TABLE IF NOT EXISTS apps_metadata (
    app_id TEXT,
    package_name TEXT,
    app_name TEXT,
    developer_name TEXT,
    category TEXT,
    installs TEXT,
    app_size_mb NUMERIC,
    content_rating TEXT,
    release_date DATE,
    latest_version TEXT,
    monetization_type TEXT,
    average_rating NUMERIC,
    min_android_version TEXT,
    has_in_app_purchases BOOLEAN,
    editor_choice BOOLEAN,
    app_popularity_score NUMERIC
);

CREATE TABLE IF NOT EXISTS user_behavior (
    user_id TEXT,
    session_id TEXT,
    app_id TEXT,
    session_duration_minutes NUMERIC,
    daily_usage_time_minutes NUMERIC,
    clicks INT,
    scrolls INT,
    retention_days INT,
    uninstall_flag BOOLEAN,
    interaction_timestamp TIMESTAMP,
    engagement_score NUMERIC,
    churn_prediction_score NUMERIC,
    anomaly_behavior_flag BOOLEAN,
    fraud_detection_signal NUMERIC,
    screen_views INT,
    notification_clicked BOOLEAN
);

CREATE TABLE IF NOT EXISTS app_reviews (
    review_id TEXT,
    app_id TEXT,
    user_id TEXT,
    rating NUMERIC,
    review_text TEXT,
    sentiment TEXT,
    helpful_votes INT,
    review_date DATE,
    reply_from_dev TEXT,
    thumbs_up INT,
    thumbs_down INT
);

CREATE TABLE IF NOT EXISTS app_download (
    app_id TEXT,
    month TEXT,
    downloads INT,
    uninstalls INT,
    updates_applied INT,
    re_installs INT,
    app_rank_category INT,
    app_rank_overall INT,
    growth_rate_pct NUMERIC
);

CREATE TABLE IF NOT EXISTS device_usage (
    user_id TEXT,
    device_model TEXT,
    os_version TEXT,
    total_daily_screen_time_minutes NUMERIC,
    apps_used_daily INT,
    background_apps INT,
    battery_consumed_pct NUMERIC,
    data_consumed_mb NUMERIC,
    wifi_usage_pct NUMERIC,
    mobile_data_usage_pct NUMERIC,
    notification_received INT,
    notification_opened INT,
    date DATE
);

CREATE TABLE IF NOT EXISTS monetization (
    app_id TEXT,
    monetization_type TEXT,
    total_revenue_usd NUMERIC,
    arpu_usd NUMERIC,
    ltv_usd NUMERIC,
    conversion_rate_pct NUMERIC,
    ad_impressions INT,
    ad_revenue_usd NUMERIC,
    in_app_purchases_count INT,
    subscription_active_users INT,
    subscription_tier TEXT,
    iap_category TEXT,
    avg_iap_value_usd NUMERIC,
    monthly_recurring_revenue_usd NUMERIC,
    churn_rate_pct NUMERIC,
    report_month TEXT
);

CREATE TABLE IF NOT EXISTS crash_reports (
    crash_id TEXT,
    app_id TEXT,
    user_id TEXT,
    crash_type TEXT,
    severity TEXT,
    device_model TEXT,
    os_version TEXT,
    app_version TEXT,
    crash_timestamp TIMESTAMP,
    uptime_before_crash_minutes NUMERIC,
    memory_usage_mb NUMERIC,
    cpu_usage_pct NUMERIC,
    network_connected BOOLEAN,
    battery_level_pct NUMERIC,
    is_foreground BOOLEAN,
    stack_trace_hash TEXT,
    resolved BOOLEAN
);

CREATE TABLE IF NOT EXISTS regional_usage (
    app_id TEXT,
    country TEXT,
    region_installs INT,
    avg_session_duration_minutes NUMERIC,
    avg_rating NUMERIC,
    revenue_usd NUMERIC,
    active_users INT,
    daus INT,
    maus INT,
    language TEXT,
    quarter TEXT,
    year INT
);

CREATE TABLE IF NOT EXISTS update_history (
    app_id TEXT,
    version_from TEXT,
    version_to TEXT,
    update_type TEXT,
    update_date DATE,
    changelog_summary TEXT,
    download_size_mb NUMERIC,
    adoption_rate_pct NUMERIC,
    crash_rate_before_pct NUMERIC,
    crash_rate_after_pct NUMERIC,
    rating_change NUMERIC,
    user_feedback_count INT
);

CREATE TABLE IF NOT EXISTS recommendation_interactions (
    user_id TEXT,
    source_app_id TEXT,
    recommended_app_id TEXT,
    interaction_type TEXT,
    recommendation_source TEXT,
    similarity_score NUMERIC,
    position_in_list INT,
    timestamp TIMESTAMP,
    session_context TEXT,
    was_installed BOOLEAN,
    time_to_action_seconds NUMERIC
);
-- Xoá toàn bộ 10 bảng (trong trường hợp muốn chạy lại từ đầu)
-- DROP TABLE IF EXISTS
--     apps_metadata,
--     user_behavior,
--     app_reviews,
--     app_download,
--     device_usage,
--     monetization,
--     crash_reports,
--     regional_usage,
--     update_history,
--     recommendation_interactions
-- CASCADE;

-- ============================================
--Import data vào trong postgres
-- ============================================
TRUNCATE TABLE apps_metadata;
copy apps_metadata from '/data/apps_metadata.csv' WITH (FORMAT csv, header true, delimiter ',');
TRUNCATE TABLE user_behavior;
copy user_behavior from '/data/user_behavior.csv' WITH (FORMAT csv, header true, delimiter ',');
TRUNCATE TABLE crash_reports;
copy crash_reports from '/data/app_crash_reports.csv' with (FORMAT csv, header true, delimiter ',');
TRUNCATE TABLE app_download;
copy app_download from '/data/app_download_trends.csv' with (format csv, header true, delimiter ',');
TRUNCATE TABLE app_reviews;
copy app_reviews from '/data/app_ratings_reviews.csv' with (format csv, header true, delimiter ',');
TRUNCATE TABLE update_history;
copy update_history from '/data/app_update_history.csv' with (format csv, header true, delimiter ',');
TRUNCATE TABLE device_usage;
copy device_usage from '/data/device_usage_stats.csv' with (format csv, header true, delimiter ',');
TRUNCATE TABLE monetization;
copy monetization from '/data/monetization_metrics.csv' with (format csv, header true, delimiter ',');
TRUNCATE TABLE recommendation_interactions;
copy recommendation_interactions from '/data/recommendation_interactions.csv' with (format csv, header true, delimiter ',');
TRUNCATE TABLE regional_usage;
copy regional_usage from '/data/regional_usage.csv' with (format csv, header true, delimiter ',');

-- ============================================
-- Kiểm tra định dạng một số bảng đáng nghi
-- ============================================
-- Bảng user_behavior
select distinct u.uninstall_flag
from user_behavior as u -- => boolean

select distinct u.anomaly_behavior_flag
from user_behavior as u-- => boolean

SELECT distinct u.fraud_detection_signal
from user_behavior as u-- => int (0/1)

SELECT max(u.engagement_score)
from user_behavior as u --=> numeric 0-100
select max(u.churn_prediction_score)
from user_behavior as u  --=> numeric 0-100

select u.session_duration_minutes, u.daily_usage_time_minutes
from user_behavior as u
limit 5 --=> numeric

-- Bảng app_reviews
select distinct r.reply_from_dev
from app_reviews as r --=> boolean

-- Bảng update_history
SELECT distinct up.changelog_summary 
from update_history as up --=> text

-- ============================================
-- Đếm số lượng các dòng mỗi bảng
-- ===========================================
select 'apps_metadata' as table_names, count(*) from apps_metadata
union all select 'user_behavior', count(*) from user_behavior
union all select 'app_reviews', count(*) from app_reviews
union all select 'app_download', count(*) from app_download
union all select 'device_usage', count(*) from device_usage
union all select 'monetization', count(*) from monetization
union all select 'crash_report', count(*) from crash_reports
union all select 'regional_usage', count(*) from regional_usage
union all select 'update_history', count(*) from update_history
union all select 'recommendation', count(*) from recommendation_interactions

-- ============================================
-- Verify các giá trị categorical cần thiết => không tồn tại giá trị lạ
-- ============================================
select distinct monetization_type
from monetization 

select distinct severity
from crash_reports

select distinct sentiment
from app_reviews

select distinct interaction_type
from recommendation_interactions

select distinct quarter
from regional_usage

select distinct update_type
from update_history

-- ============================================
-- Xác định grain/primary_key ở các bảng
-- ============================================
select count(distinct app_id)
from apps_metadata

select count(distinct user_id), count(DISTINCT session_id)
from user_behavior

select count(DISTINCT review_id)
from app_reviews

select count(distinct app_id)
from app_download

select count(distinct user_id), count(*)
from device_usage

select count(distinct app_id)
from monetization -- 86365 => app_id không phải grain

select count(distinct crash_id), count(*)
from crash_reports

select count(distinct app_id), count(*)
from regional_usage

select count(distinct app_id), count(*)
from update_history

select count(distinct user_id), count(distinct source_app_id), count(*)
from recommendation_interactions

-- Xác định grain cho bảng monetization
select app_id, monetization_type, subscription_tier, iap_category, report_month
from monetization
where app_id in (
    select app_id
    from monetization
    group by app_id
    having count(app_id)>1
    )
order by app_id, report_month

select count(*)
from (
    select app_id, monetization_type, subscription_tier, iap_category, report_month, in_app_purchases_count
    from monetization
    group by app_id, monetization_type, subscription_tier, iap_category, report_month, in_app_purchases_count
) as t

with dup_groups as (
    select app_id, report_month, subscription_tier, iap_category, monetization_type
    from monetization
    group by app_id, report_month, subscription_tier, iap_category,monetization_type
    having count(*) > 1
    limit 10
)
select m.*
from monetization m
join dup_groups d
  on m.app_id = d.app_id
 and m.report_month = d.report_month
 and m.subscription_tier = d.subscription_tier
 and m.iap_category = d.iap_category
order by m.app_id, m.report_month;
-- => Tồn tại các dòng trùng nhau ở tất cả các yếu tố phân loại của bảng, đây là yếu tố hạn chế của dataset này vì dữ liệu là synthetic, ta sẽ giữ lại gộp chung sau

-- ============================================
-- Kiểm tra giá trị một số bảng khả nghi
-- ============================================
-- Vì dữ liệu gốc là dữ liệu synthetic nên có nguy cơ tồn tại sự không đồng nhất giữa các bảng, ta tiến hành kiểm tra tính thống nhất giữa một số bảng khả nghi
-- Kiểm tra average_rating từ metadata và app reviews
with ar as (
    select app_id, avg(rating) as avg_rt
    from app_reviews
    group by app_id
)
select mt.app_id, mt.average_rating, ar.avg_rt, round(mt.average_rating - ar.avg_rt,2) as diff 
from apps_metadata as mt
join ar
on mt.app_id = ar.app_id
limit 10 -- có sai lệch
-- Vì có sự sai lệch nên tính toán mức độ sai lệch tổng quát
with ar as (
    select app_id, avg(rating) as avg_rt
    from app_reviews
    group by app_id
)
select round(avg(abs(diff)),2) as mean_abs_diff,
count(*) filter(where abs(diff)>0.5) as over_diff,
count(*) as total_apps
from (select mt.app_id, mt.average_rating, ar.avg_rt, round(mt.average_rating - ar.avg_rt,2) as diff 
from apps_metadata as mt
join ar
on mt.app_id = ar.app_id) as abc -- Số app sai lệch quá 0.5 sao chỉ chiếm khoảng 2,4% và sai lệch trung bình là 0.18
-- => Dự liệu có thể sử dụng được, các app chênh lệch rating quá nhiều sẽ được phân tích sau trong python

-- Kiểm tra nhất quán số user giữa 2 bảng user behavỉor và monetization, cho thấy số user không nhất quán giữa 2 bảng 
select mn.app_id, count(distinct user_id)
from monetization as mn
join user_behavior as ub
on mn.app_id = ub.app_id
group by mn.app_id
order by app_id desc

--Kiểm tra monet logic của bảng app_metadata
select distinct monetization_type
from apps_metadata
where has_in_app_purchases = 'False' -- Như vậy cột has_in_app_purchases có cách tính khác với monetization_type, trong trường hợp này ta giả định cột has_in_app_purchases là sai và loại bỏ

-- KIểm tra quy tắc của monet type
select 
    am.app_id, 
    has_in_app_purchases, 
    am.monetization_type, 
    mn.iap_category, 
    mn.monetization_type,  
    in_app_purchases_count,  
    avg_iap_value_usd, 
    ad_revenue_usd, 
    subscription_active_users, 
    total_revenue_usd, 
    monthly_recurring_revenue_usd
from apps_metadata as am
join monetization as mn
on am.app_id = mn.app_id
where mn.monetization_type = 'Subscription'
order by  mn.app_id asc, mn.monetization_type , in_app_purchases_count asc, avg_iap_value_usd asc

select 
    mn.monetization_type, 
    count(distinct total_revenue_usd) as total_rev, 
    count(distinct arpu_usd) as arpu, 
    count(distinct ltv_usd) as ltv, 
    count(distinct ad_impressions) as ad_impression, 
    count(distinct ad_revenue_usd) as ad_rev, 
    count(distinct in_app_purchases_count) as iap_count, 
    count(distinct subscription_active_users) as subscription_count,
    count(distinct subscription_tier) as subs_tier, 
    count(distinct iap_category) as iap_cate, 
    count(distinct avg_iap_value_usd) as avg_iap, 
    count(distinct monthly_recurring_revenue_usd) as mrr
from apps_metadata as am
join monetization as mn
on am.app_id = mn.app_id
group by mn.monetization_type
-- Ta có nhận xét sau:
-- Free thì iap_category là NA, ad_revenue =0 và subscription_active_users là 0, ltv có 7 giá trị và đều xếp xỉ 0 (0,07; 0,06), arpu co 52 gia tri max la 0.05
-- Freemium thì có nhiều iap category (7 loai), ad_revenue >0 và subscription = 0, arpu max > 0,5, ltv max = ~6
-- Free with ads thì iap category là NA, subscripton =0 và ad revenue > 0, ltv max 0.36, arpu max > 0,3 
-- Paid thì giống iap cate la NA, subscription = 0, ad =0, nhưng nhiều giá trị distinct arpu và ltv. các giá trị này cũng cao (arpu 6.9 va ltv 79)
-- Subscription thì iap cate là NA, ad_revenue =0 và subscription_active_users > 0, subscription tier =4, ltv va arpu cũng cao
-- => Có logic phân loại trong monet_type, các mô hình thu tiền có hiệu quả nguồn tiền (ltv và arpu) phù hợp với thực tế (Free thấp nhát trong khi subscription và paid lại cao nhất)

-- Kiểm tra 2 cột đã được tính toán sẵn là conversion_rate_pct và churn_rate_pct
select 
    monetization_type, 
    count(app_id), 
    count(distinct conversion_rate_pct) as cvr, 
    count(distinct churn_rate_pct) as churn
from monetization
group by monetization_type -- Số lượng unique value tương đồng ở nhiều nhóm, cho thấy bản chất và hạn chế của dữ liệu sythentic, tuy nhiên conversion rate có logic nhất định giữ lại conversion_rate

-- Kiểm tra các cột doanh thu và nguồn tiền
select 
    total_revenue_usd, 
    in_app_purchases_count,  
    avg_iap_value_usd, 
    monthly_recurring_revenue_usd
from apps_metadata as am
join monetization as mn
on am.app_id = mn.app_id
where mn.monetization_type = 'Free' and category = 'Games' -- Kể cả với các app free thì các cột avg_iap_value, mrr, iap_count vẫn nhận giá trị, điều này cho thấy phân phối giống hệt nhau ở mọi type và và không nhất quán với monet_type trong phạm vi của dataset
-- => Loại bỏ 3 cột này và giả định không có liên hệ tới total_revenue

-- Kiểm tra số lượng user tạo từ total_revenue/arpu ổn định qua các report month, cho thấy thuật toán không mô phỏng biến động user và là giới hạn của dataset này.
select 
    app_id, 
    avg(total_revenue_usd/arpu_usd), 
    stddev(total_revenue_usd/arpu_usd)
from monetization
where arpu_usd != 0
group by app_id
order by app_id desc

-- kiểm tra ltv/arpu lại cho kết quả biến động ở nhiều app
select 
    app_id, 
    avg(ltv_usd/arpu_usd) , 
    stddev(ltv_usd/arpu_usd)
from monetization
where arpu_usd != 0
group by app_id
order by app_id desc

-- ============================================
-- Lọc ra các game apps và kiểm tra số dòng sau khi lọc
-- ============================================
select count(*)
from apps_metadata
where category = 'Games' -- 17042 apps (17% của 100000 apps)

select 
    count(distinct mn.app_id) as NoGames, 
    count(*) as NoRecord
from apps_metadata as am
join monetization as mn
on am.app_id = mn.app_id
where category = 'Games' -- 14686 games có trong bảng monet và 34168 records. 

select 
    count(distinct am.app_id) as NoGames, 
    count(*) as NoRecord
from apps_metadata as am
join crash_reports as cr
on am.app_id = cr.app_id
where am.category = 'Games' --14755 games có trong bảng crash_report và 33393 record
-- Số lượng game trong bảng là khác nhau vì nhiều lý do (game ko bị crash không tồn tại trong bảng crash_report - yếu tố business/kỹ thuật; missing data như bảng monet - yếu tố khách quan cúa thu thập dữ liệu) nên ta không lọc game/app_id ở các bảng

-- ============================================
-- tạo các bảng lọc theo games, loại bỏ 4 bảng ít ảnh hưởng là device_usage, apps_download, update_history, recommendation_interaction
-- ============================================
-- 1. apps_metadata_f: bảng gốc chứa danh sách game
drop table if exists apps_metadata_f;
create table apps_metadata_f as
select app_id, app_name, developer_name, installs, app_size_mb, content_rating, release_date, monetization_type, average_rating, editor_choice
from apps_metadata
where category = 'Games';

-- 2. monetization_f
-- loại: in_app_purchases_count, avg_iap_value_usd, monthly_recurring_revenue_usd (vi phạm rule type), churn_rate_pct (cùng pool 1901 giá trị ở mọi type → độc lập với type)
drop table if exists monetization_f;
create table monetization_f as
select app_id, monetization_type, total_revenue_usd, arpu_usd, ltv_usd, conversion_rate_pct, ad_impressions, ad_revenue_usd, subscription_active_users, subscription_tier, iap_category, report_month
from monetization
where app_id in (select app_id from apps_metadata_f);

-- 3. user_behavior_f
-- loại: engagement_score, churn_prediction_score, anomaly_behavior_flag, fraud_detection_signal (đều là score/flag ước lượng sẵn, không phải quan sát thô)
drop table if exists user_behavior_f;
create table user_behavior_f as
select user_id, session_id, app_id, session_duration_minutes, daily_usage_time_minutes, clicks, scrolls, screen_views, retention_days, uninstall_flag, interaction_timestamp, notification_clicked
from user_behavior
where app_id in (select app_id from apps_metadata_f);

-- 4. app_reviews_f
drop table if exists app_reviews_f;
create table app_reviews_f as
select review_id, app_id, user_id, rating, review_text, sentiment, helpful_votes, review_date, reply_from_dev
from app_reviews
where app_id in (select app_id from apps_metadata_f);

-- 5. crash_reports_f
-- loại: các cột chi tiết kỹ thuật (device_model, os_version, memory, cpu, battery, network_connected, is_foreground, stack_trace_hash, uptime_before_crash)
drop table if exists crash_reports_f;
create table crash_reports_f as
select crash_id, app_id, user_id, crash_type, severity, app_version, crash_timestamp, resolved
from crash_reports
where app_id in (select app_id from apps_metadata_f);

-- 6. regional_usage_f: giữ toàn bộ cột
drop table if exists regional_usage_f;
create table regional_usage_f as
select *
from regional_usage
where app_id in (select app_id from apps_metadata_f);

-- ============================================
-- đánh index cho các bảng
-- ============================================
create index idx_apps_metadata_f_app_id on apps_metadata_f(app_id);
create index idx_apps_metadata_f_montype on apps_metadata_f(monetization_type);

create index idx_monetization_f_app_id on monetization_f(app_id);
create index idx_monetization_f_montype on monetization_f(monetization_type);

create index idx_user_behavior_f_app_id on user_behavior_f(app_id);
create index idx_user_behavior_f_user_id on user_behavior_f(user_id);

create index idx_app_reviews_f_app_id on app_reviews_f(app_id);

create index idx_crash_reports_f_app_id on crash_reports_f(app_id);

create index idx_regional_usage_f_app_id on regional_usage_f(app_id);

-- kiểm tra sau khi tạo
select 'apps_metadata_f' as table_name, count(*) as rows, count(distinct app_id) as games from apps_metadata_f
union all select 'monetization_f', count(*), count(distinct app_id) from monetization_f
union all select 'user_behavior_f', count(*), count(distinct app_id) from user_behavior_f
union all select 'app_reviews_f', count(*), count(distinct app_id) from app_reviews_f
union all select 'crash_reports_f', count(*), count(distinct app_id) from crash_reports_f
union all select 'regional_usage_f', count(*), count(distinct app_id) from regional_usage_f;


-- ============================================
-- tạo game_master: 1 dòng/game - 14,686 game có dữ liệu monetization
-- ============================================
drop table if exists game_master;

create table game_master as
with monet as (
    select
        app_id,
        max(monetization_type) as monetization_type,
        sum(total_revenue_usd) as total_revenue,
        sum(total_revenue_usd) / count(distinct report_month) as avg_revenue_per_month,
        avg(arpu_usd) as avg_arpu,
        avg(ltv_usd) as avg_ltv,
        avg(conversion_rate_pct) as avg_conversion_rate,
        sum(ad_revenue_usd) as total_ad_revenue,
        sum(ad_impressions) as total_ad_impressions,
        sum(subscription_active_users) as total_sub_users,
        count(distinct report_month) as n_months
    from monetization_f
    group by app_id
),

behavior as (
    select
        app_id,
        count(distinct user_id) as n_users,
        count(*) as n_sessions,
        avg(session_duration_minutes) as avg_session_duration,
        avg(daily_usage_time_minutes) as avg_daily_usage,
        avg(clicks) as avg_clicks,
        avg(scrolls) as avg_scrolls,
        avg(screen_views) as avg_screen_views,
        avg(retention_days) as avg_retention_days,
        avg(case when uninstall_flag then 1.0 else 0.0 end) as uninstall_rate,
        avg(case when notification_clicked then 1.0 else 0.0 end) as notif_click_rate
    from user_behavior_f
    group by app_id
),

reviews as (
    select
        app_id,
        count(*) as n_reviews,
        avg(rating) as avg_review_rating,
        avg(case when sentiment = 'Positive' then 1.0 else 0.0 end) as positive_rate,
        avg(case when sentiment = 'Negative' then 1.0 else 0.0 end) as negative_rate,
        avg(helpful_votes) as avg_helpful_votes
    from app_reviews_f
    group by app_id
),

crash as (
    select
        app_id,
        count(*) as n_crashes,
        avg(case when severity in ('High', 'Critical') then 1.0 else 0.0 end) as severe_crash_rate,
        avg(case when resolved then 1.0 else 0.0 end) as crash_resolved_rate
    from crash_reports_f
    group by app_id
)

select
    -- thông tin cơ bản
    am.app_id,
    am.app_name,
    mn.monetization_type,
    am.installs,
    am.content_rating,
    am.release_date,
    am.app_size_mb,
    am.average_rating,
    am.editor_choice,

    -- doanh thu
    mn.total_revenue,
    mn.avg_revenue_per_month,
    mn.avg_arpu,
    mn.avg_ltv,
    mn.avg_conversion_rate,
    mn.total_ad_revenue,
    mn.total_ad_impressions,
    mn.total_sub_users,
    mn.n_months,

    -- hành vi
    be.n_users,
    be.n_sessions,
    be.avg_session_duration,
    be.avg_daily_usage,
    be.avg_clicks,
    be.avg_scrolls,
    be.avg_screen_views,
    be.avg_retention_days,
    be.uninstall_rate,
    be.notif_click_rate,

    -- review
    re.n_reviews,
    re.avg_review_rating,
    re.positive_rate,
    re.negative_rate,
    re.avg_helpful_votes,

    -- crash: fill 0 vì không có crash đồng nghĩa với không crash
    coalesce(cr.n_crashes, 0) as n_crashes,
    coalesce(cr.severe_crash_rate, 0) as severe_crash_rate,
    coalesce(cr.crash_resolved_rate, 0) as crash_resolved_rate,
    case when cr.app_id is null then 0 else 1 end as has_crash_data

from monet as mn
join apps_metadata_f am on mn.app_id = am.app_id
left join behavior be on mn.app_id = be.app_id
left join reviews re on mn.app_id = re.app_id
left join crash cr on mn.app_id = cr.app_id;


-- ============================================
-- thêm cột tier quy mô (chia đều tertile theo installs)
-- installs là bucket string "1,000,000+" nên phải parse thành số trước
-- ============================================

-- thêm cột installs dạng số
alter table game_master add column installs_num bigint;

update game_master
set installs_num = cast(replace(replace(installs, ',', ''), '+', '') as bigint);

-- thêm cột tier
alter table game_master add column size_tier text;

update game_master as gm
set size_tier = t.tier
from (
    select
        app_id,
        case ntile(3) over (order by installs_num desc)
        when 1 then 'Top'
        when 2 then 'Mid'
        else 'Long-tail'
        end as tier
    from game_master
) as t
where gm.app_id = t.app_id;

-- kiểm tra
select count(*) as n_games, count(distinct app_id) as unique_games from game_master;

select 
    size_tier, count(*) as n_games,
    min(installs_num) as min_installs,
    max(installs_num) as max_installs
from game_master
group by size_tier;

select
    monetization_type, count(*) as n_games,
    round(avg(avg_arpu), 4) as arpu,
    round(avg(avg_ltv), 2) as ltv
from game_master
group by monetization_type
order by arpu desc;

-- ============================================
-- xuất ra file csv, có thể export để kiểm tra và thử lại
-- ============================================
copy game_master to '/data/game_master.csv' with (format csv, header true);
copy monetization_f to '/data/monetization_f.csv' with (format csv, header true);
copy regional_usage_f to '/data/regional_usage_f.csv' with (format csv, header true);