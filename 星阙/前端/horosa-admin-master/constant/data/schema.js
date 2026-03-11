import { z } from "zod"

// We're keeping a simple non-relational schema here.
// IRL, you will have a schema for your data models.
export const taskSchema = z.object({
  id: z.string(),
  title: z.string(),
  status: z.string(),
  label: z.string(),
  priority: z.string(),
})

// 用户管理
export const userSchema = z.object({
  // 用户昵称
  nickname: z.string(),
  // 用户微信号
  wechat: z.string(),
  // 性别
  gender: z.string(),
  // 出生日期
  birthday: z.string(),
  // 出生地
  birthplace: z.string(),
  // 现居地
  place: z.string(),
})

// 金刚区管理
export const dockSchema = z.object({
  // 金刚区名
  name: z.string(),
  // 图标
  icon: z.string(),
  // 标识
  identifier: z.string(),
  // 排序
  sort: z.number(),
  // 状态
  status: z.number(),
})

// 用户反馈
export const feedbackSchema = z.object({
  // 反馈时间
  time: z.string(),
  // 用户昵称
  nickname: z.string(),
  // 用户微信号
  wechat: z.string(),
  // 用户姓名
  username: z.string(),
  // 反馈内容
  content: z.string(),
})