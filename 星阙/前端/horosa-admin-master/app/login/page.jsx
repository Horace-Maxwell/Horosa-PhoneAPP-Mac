'use client'

import { useRouter, useSearchParams } from 'next/navigation'
import * as React from 'react'
import { IconLogo } from '@/components/icons'
import { useForm } from 'react-hook-form'
import { Form, FormField, FormControl, FormLabel, FormItem, FormMessage } from '@/components/ui/form'
import { useAuthorizer } from "@/providers/authorizer-provider"
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { zodResolver } from "@hookform/resolvers/zod"
import { StorageUtils } from '@/lib/storage'
import { KEYS } from '@/constant/keys'
import { z } from 'zod'

const formSchema = z.object({
  username: z.string().min(1, {
    message: "账号不能为空！",
  }),
  password: z.string().min(1, {
    message: "密码不能为空！",
  }),
})

export default function LoginPage() {

  const router = useRouter()
  const searchParams = useSearchParams()
  const from = searchParams.get('from')

  const { isLoggedIn } = useAuthorizer()

  const form = useForm({
    resolver: zodResolver(formSchema),
    defaultValues: {
      username: "",
      password: ""
    },
  })

  const handleSignIn = ({ username, password }) => {
    console.log({ username, password })
    fetch('https://api.horosa.com/admin/user/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ username, password }),
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        StorageUtils.set(KEYS.ACCESS_TOKEN, res.data.token)
        // router.replace(redirect || '/')
        router.replace(from || '/')
      }
    })
  }

  function onSubmit(values) {
    // Do something with the form values.
    // ✅ This will be type-safe and validated.
    handleSignIn(values)
  }

  React.useEffect(() => {
    if (isLoggedIn) {
      router.replace(from || '/');

      return;
    }
  }, [from, isLoggedIn, router])

  return (
    <main className='flex w-full h-svh p-4'>
      <div className='flex-1 flex items-center justify-center rounded-3xl bg-foreground'>
        <div className='flex items-center space-x-3'>
          <IconLogo className='w-12 h-12 fill-background' />
          <h1 className='text-5xl text-background font-semibold'>HOROSA</h1>
        </div>
      </div>
      <div className='flex-1 flex flex-col items-center justify-center'>
        <div className='w-96'>
          <span className='block mb-8 text-2xl font-semibold'>欢迎回来！👋</span>
          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
              <FormField
                control={form.control}
                name="username"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className='font-semibold'>账号</FormLabel>
                    <FormControl>
                      <Input placeholder="请输入账号~" className='h-10' {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="password"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className='font-semibold'>密码</FormLabel>
                    <FormControl>
                      <Input type="password" placeholder="请输入密码~" className='h-10' {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <Button className='w-full h-12 text-base' type="submit">登 录</Button>
            </form>
          </Form>
        </div>
      </div>
    </main>
  )
}
