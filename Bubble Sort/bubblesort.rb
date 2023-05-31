arr = 4,3,78,2,0,2

def bubblesort(arr)
    arr.each_index { |i|
    arr[0...arr.size-i-1].each_index { |j|
        if arr[j]>arr[j+1]
            arr[j+1],arr[j]=arr[j],arr[j+1]
        end
    }
    }
    arr
end

print bubblesort(arr)