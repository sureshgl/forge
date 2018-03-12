package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Parallel_edge_sensitive_path_descriptionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Parallel_edge_sensitive_path_descriptionContextExt extends AbstractBaseExt {

	public Parallel_edge_sensitive_path_descriptionContextExt(Parallel_edge_sensitive_path_descriptionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Parallel_edge_sensitive_path_descriptionContext getContext() {
		return (Parallel_edge_sensitive_path_descriptionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor()
				.visit(getPrimeParser(str).parallel_edge_sensitive_path_description());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Parallel_edge_sensitive_path_descriptionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Parallel_edge_sensitive_path_descriptionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}