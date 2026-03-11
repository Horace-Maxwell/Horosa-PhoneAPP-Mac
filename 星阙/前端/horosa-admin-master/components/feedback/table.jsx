"use client";

import * as React from "react";
import { DataTable } from "@/components/table";
import { columns } from "@/components/table/columns/feedbacks";
import { DataTableToolbar } from "@/components/table/toolbars/feedbacks";
import { StorageUtils } from "@/lib/storage";
import { KEYS } from "@/constant/keys";

export function FeedbackTable() {
  const [feedbacks, setFeedbacks] = React.useState([])
  const [total, setTotal] = React.useState(0)
  const [pageIndex, setPageIndex] = React.useState(0)

  const getFeedbacks = ({ page = 1, pageSize = 10 }) => {
    fetch('https://api.horosa.com/admin/suggest/list', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': StorageUtils.get(KEYS.ACCESS_TOKEN),
      },
      body: '{ "page": ' + page + ', "page_size": ' + pageSize + ' }',
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        setFeedbacks(res.data?.data)
        setTotal(res.data?.total || 0)
      }
    })
  }

  const list = () => {
    getFeedbacks({ page: pageIndex + 1, pageSize: 10 })
  }

  React.useEffect(() => {
    getFeedbacks({ page: pageIndex + 1, pageSize: 10 })
  }, [pageIndex])

  return (
    <>
      <DataTable
        data={feedbacks}
        columns={columns({ actions: { list } })}
        toolbar={<DataTableToolbar />}
        total={total}
        pageIndex={pageIndex}
        setPageIndex={setPageIndex}
      />
    </>
  )
}
