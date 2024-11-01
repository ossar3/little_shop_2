class Api::V1::MerchantsInvoicesController < ApplicationController
    ALLOWED_STATUSES = ["shipped", "returned", "packaged"].freeze
    #makes an unchangeable array of the allowed statuses for invoices

    def index   # handling 'get' api/v1/merchants/:merchant_id/invoices
         
        status = params[:status]

        #finding the invoices
        invoices = Invoice.where(merchant_id: params[:merchant_id], status: status)
        #render
            render json: {
        data: invoices.map do |invoice|
            {
            id: invoice.id.to_s,
            type: "invoice",
            attributes: {
                customer_id: invoice.customer_id.to_s,
                merchant_id: invoice.merchant_id.to_s,
                status: invoice.status
            }
            }
        end
        }
    end
    
            

end