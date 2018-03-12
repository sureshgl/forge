package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Array_method_nameContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Array_method_nameContextExt extends AbstractBaseExt {

	public Array_method_nameContextExt(Array_method_nameContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Array_method_nameContext getContext() {
		return (Array_method_nameContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).array_method_name());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Array_method_nameContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Array_method_nameContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}