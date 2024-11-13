-- create table `play_log` (
--     `fdate` date,
--     `user_id` int,
--     `song_id` int
-- );

-- create table `song_info` (
--     `song_id` int,
--     `song_name` varchar(255),
--     `singer_name` varchar(255)
-- );

-- create table `user_info` (
--     `user_id`   int,
--     `age`       int
-- );
-- 从听歌流水中找到18-25岁用户在2022年每个月播放次数top 3的周杰伦的歌曲

# month|ranking|song_name|play_pv
select month, ranking, song_name, play_pv
from (select month(pl.fdate)                                                                    month,
             ROW_NUMBER() OVER (PARTITION BY month(pl.fdate) order by count(*) desc,song_id) as ranking,
             song_name,
             song_id,
             count(*)                                                                        as play_pv
      from play_log pl
               join song_info si using (song_id)
               join user_info ui using (user_id)
      where ui.age between 18 and 25
        and year(pl.fdate) = 2022
        and si.singer_name = '周杰伦'
      group by month, song_name, si.song_id) t
where ranking <= 3;

