import {
  ArrowDownIcon,
  ArrowRightIcon,
  ArrowUpIcon,
} from "@radix-ui/react-icons"

export const gender = {
  0: "未知",
  1: "男",
  2: "女",
}

export const genders = [
  {
    value: 0,
    label: "未知",
  },
  {
    value: 1,
    label: "男",
  },
  {
    value: 2,
    label: "女",
  }
]

export const statuses = [
  {
    value: 1,
    label: "启用",
  },
  {
    value: 2,
    label: "禁用",
  }
]

export const priorities = [
  {
    label: "Low",
    value: "low",
    icon: ArrowDownIcon,
  },
  {
    label: "Medium",
    value: "medium",
    icon: ArrowRightIcon,
  },
  {
    label: "High",
    value: "high",
    icon: ArrowUpIcon,
  },
]