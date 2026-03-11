import { Skeleton } from './ui/skeleton';
import { Card, CardHeader, CardContent } from './ui/card';

export default function LayoutSkeleton() {
  return (
    <main className="flex flex-col w-screen h-screen">
      <header className="flex justify-between items-center px-3 py-2 h-16 border-b">
        <div className="flex items-center space-x-2">
          <Skeleton className="w-8 h-8 rounded-full" />
          <Skeleton className="w-32 h-6" />
        </div>
        <Skeleton className="w-8 h-8 rounded-full" />
      </header>
      <div className="flex flex-grow overflow-hidden">
        <div className="max-w-80 h-full border-r">
          <div className='flex flex-col space-y-4 w-80 p-4'>
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
            <Skeleton className="w-full h-8" />
          </div>
        </div>
        <div className="flex-grow p-4 min-w-[1280px] overflow-hidden">
          <Card className="flex-grow h-full p-4 overflow-hidden">
            <CardHeader className="p-0" />
            <CardContent className="p-0 space-y-4">
              <Skeleton className="w-full h-40" />
              <Skeleton className="w-full h-40" />
              <Skeleton className="w-full h-40" />
              <Skeleton className="w-full h-20" />
              <Skeleton className="w-full h-20" />
            </CardContent>
          </Card>
        </div>
      </div>
    </main>
  )
}
