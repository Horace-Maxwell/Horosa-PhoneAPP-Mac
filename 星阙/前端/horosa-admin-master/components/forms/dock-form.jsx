"use client";

import { Input } from '../ui/input'
import { Button } from '../ui/button'
import { Switch } from '../ui/switch'
import ImageUpload from './image-upload'
import { useForm } from 'react-hook-form'
import { Form, FormField, FormControl, FormLabel, FormItem, FormMessage } from '@/components/ui/form'
import { zodResolver } from "@hookform/resolvers/zod"
import { z } from 'zod'
import { StorageUtils } from '@/lib/storage';
import { KEYS } from '@/constant/keys';

const formSchema = z.object({
  logo: z.string().min(10, {
    message: "请上传图标！",
  }),
  name: z.string().min(2, {
    message: "名称不能为空！",
  }),
  ident: z.string().min(1, {
    message: "标识不能为空！",
  }),
  sort: z.number().default('0'),
  status: z.number().default(1)
})

export default function DockEditForm({ record, onClose }) {
  const form = useForm({
    resolver: zodResolver(formSchema),
    defaultValues: {
      id: record?.id || "",
      logo: record?.logo || "",
      name: record?.name || "",
      ident: record?.ident || "",
      sort: record?.sort || 0,
      status: record?.status || 1
    },
  })

  function onSubmit(values) {
    // Do something with the form values.
    // ✅ This will be type-safe and validated.
    console.log(values)
    values.id = record?.id;
    fetch('https://api.horosa.com/admin/quick_link/modify', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': StorageUtils.get(KEYS.ACCESS_TOKEN),
      },
      body: JSON.stringify(values),
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        onClose?.();
      }
    })

  }

  return (
    <div>
      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-2">
          <FormField
            control={form.control}
            name="logo"
            render={({ field }) => (
              <FormItem className="flex items-center">
                <FormLabel className='flex-shrink-0 w-20 font-semibold'>上传图标</FormLabel>
                <div className='w-full space-y-1'>
                  {/* {field.value && <Image src={field.value} alt="icon" width={36} height={36} />} */}
                  <FormControl>
                    <ImageUpload
                      value={field.value}
                      onChange={
                        (e) => {
                          if(e) {
                            if(e?.size > 100 * 1024) {
                              alert('图标大小不能超过 100KB')
                            } else {
                              field.onChange(e?.src)
                            }
                          } else {
                            field.onChange('')
                          }
                        }
                      }
                    />
                  </FormControl>
                  <FormMessage />
                </div>
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="name"
            render={({ field }) => (
              <FormItem className="flex items-center">
                <FormLabel className='flex-shrink-0 w-20 font-semibold'>名称</FormLabel>
                <div className='w-full space-y-1'>
                  <FormControl>
                    <Input placeholder="请输入名称~" className='h-10' {...field} />
                  </FormControl>
                  <FormMessage />
                </div>
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="ident"
            render={({ field }) => (
              <FormItem className="flex items-center">
                <FormLabel className='flex-shrink-0 w-20 font-semibold'>标识</FormLabel>
                <div className='w-full space-y-1'>
                  <FormControl>
                    <Input placeholder="请输入标识~" className='h-10' {...field} disabled />
                  </FormControl>
                  <FormMessage />
                </div>
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="sort"
            render={({ field }) => (
              <FormItem className="flex items-center">
                <FormLabel className='flex-shrink-0 w-20 font-semibold'>排序</FormLabel>
                <div className='w-full space-y-1'>
                  <FormControl>
                    <Input
                      placeholder="请输入排序值~"
                      className='w-full h-10'
                      value={field.value}
                      onChange={(e) => field.onChange(e.target.value)}
                      onBlur={
                        (e) => {
                          const value = e.target.value
                          if (isNaN(parseInt(value))) {
                            field.onChange(0)
                          } else {
                            field.onChange(parseInt(value))
                          }
                        }
                      }
                    />
                  </FormControl>
                  <FormMessage />
                </div>
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="status"
            render={({ field }) => (
              <FormItem className="flex items-center">
                <FormLabel className='flex-shrink-0 w-20 font-semibold'>是否启用</FormLabel>
                <div className='w-full space-y-1'>
                  <FormControl>
                    <Switch
                      checked={field.value === 1}
                      onCheckedChange={
                        (checked) => field.onChange(checked ? 1 : 2)
                      }
                    />
                  </FormControl>
                  <FormMessage />
                </div>
              </FormItem>
            )}
          />

          <div className="pt-4 w-full">
            <Button className="w-full" type="submit">保存</Button>
          </div>
        </form>
      </Form>
    </div>
  )
}
