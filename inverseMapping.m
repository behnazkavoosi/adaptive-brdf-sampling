function invData = inverseMapping(data, data_ref, data_epsilon, weight)
    invData = exp(data);
    invData = invData.*(data_ref  + data_epsilon);
    invData = invData - data_epsilon;
    invData = invData./weight;

end
