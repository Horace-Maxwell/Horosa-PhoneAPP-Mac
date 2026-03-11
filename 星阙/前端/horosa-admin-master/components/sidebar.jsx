"use client";

import * as React from "react";
import { useRouter, usePathname } from "next/navigation";
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"

export default function Sidebar({ className }) {
  const router = useRouter()
  const pathname = usePathname()

  return (
    <div className={cn("pb-12", className)}>
      <div className="px-3 py-3">
        <div className="space-y-4">
          <Button
            variant={pathname == "/dashboard" ? "secondary" : "ghost"}
            className={cn("w-full justify-start", pathname == "/dashboard" && "font-semibold")}
            onClick={() => router.push("/dashboard")}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="mr-2 h-5 w-5"
            >
              <circle cx="12" cy="12" r="10" />
              <polygon points="10 8 16 12 10 16 10 8" />
            </svg>
            数据看版
          </Button>
          <Button
            variant={pathname == "/user" ? "secondary" : "ghost"}
            className={cn("w-full justify-start", pathname == "/user" && "font-semibold")}
            onClick={() => router.push("/user")}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="mr-2 h-5 w-5"
            >
              <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
              <circle cx="12" cy="7" r="4" />
            </svg>
            用户管理
          </Button>
          <Button
            variant={pathname == "/dock" ? "secondary" : "ghost"}
            className={cn("w-full justify-start", pathname == "/dock" && "font-semibold")}
            onClick={() => router.push("/dock")}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="mr-2 h-5 w-5"
            >
              <rect width="7" height="7" x="3" y="3" rx="1" />
              <rect width="7" height="7" x="14" y="3" rx="1" />
              <rect width="7" height="7" x="14" y="14" rx="1" />
              <rect width="7" height="7" x="3" y="14" rx="1" />
            </svg>
            金刚区管理
          </Button>
          <Button
            variant={pathname == "/feedback" ? "secondary" : "ghost"}
            className={cn("w-full justify-start", pathname == "/feedback" && "font-semibold")}
            onClick={() => router.push("/feedback")}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="mr-2 h-5 w-5"
            >
              <path d="M4.9 19.1C1 15.2 1 8.8 4.9 4.9" />
              <path d="M7.8 16.2c-2.3-2.3-2.3-6.1 0-8.5" />
              <circle cx="12" cy="12" r="2" />
              <path d="M16.2 7.8c2.3 2.3 2.3 6.1 0 8.5" />
              <path d="M19.1 4.9C23 8.8 23 15.1 19.1 19" />
            </svg>
            用户反馈
          </Button>
        </div>
      </div>
    </div>
  )
}
