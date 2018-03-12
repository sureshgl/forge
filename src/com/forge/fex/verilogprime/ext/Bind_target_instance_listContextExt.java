package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bind_target_instance_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bind_target_instance_listContextExt extends AbstractBaseExt {

	public Bind_target_instance_listContextExt(Bind_target_instance_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bind_target_instance_listContext getContext() {
		return (Bind_target_instance_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bind_target_instance_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bind_target_instance_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Bind_target_instance_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}