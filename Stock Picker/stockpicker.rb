arr = 17,3,6,9,15,8,6,1,10

def stockpicker(arr)
    dif=0
    result=Array.new(2,0)
    arr.each_with_index { |arrval,arrind|
        max=arr[arrind...arr.length].max
        if max-arrval>dif
            dif=max-arrval
            result[0]=arrind
            result[1]=arr.index(max)
        end
    }
    result
end

print stockpicker(arr)