package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Overload_proto_formalsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Overload_proto_formalsContextExt extends AbstractBaseExt {

	public Overload_proto_formalsContextExt(Overload_proto_formalsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Overload_proto_formalsContext getContext() {
		return (Overload_proto_formalsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).overload_proto_formals());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Overload_proto_formalsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Overload_proto_formalsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}