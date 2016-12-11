-- 创建数据库
CREATE TABLE IF NOT EXISTS "T_Memo" (
"memo_id" integer NOT NULL PRIMARY KEY,
"memo_time" text,
"contents" text, -- 所有内容，含文本、图片名、录音文件名
"textContent" text, -- 所有文本内
"imageNames" text,
"voiceNum" text,
"picNum" text
);

CREATE TABLE IF NOT EXISTS "T_Label" (
"imageName" text NOT NULL PRIMARY KEY,
"points" text,
"texts" text
);
