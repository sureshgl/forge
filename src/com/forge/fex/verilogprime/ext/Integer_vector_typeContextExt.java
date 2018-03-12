package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Integer_vector_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Integer_vector_typeContextExt extends AbstractBaseExt {

	public Integer_vector_typeContextExt(Integer_vector_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Integer_vector_typeContext getContext() {
		return (Integer_vector_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).integer_vector_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Integer_vector_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Integer_vector_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}